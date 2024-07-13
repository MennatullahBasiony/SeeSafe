import os
from ultralytics import YOLO
from labels import Labels

class Detection:

    def __init__(self, usedIndooModel='yolov8l-oiv7.pt'):
        self.filePath = os.path.abspath(__file__)
        self.dirPath = os.path.dirname(os.path.abspath(__file__))

        #---------  Indoor --------#
        self.usedIndoorModel = usedIndooModel
        if usedIndooModel == "coco":    self.usedIndoorModel = "yolov8m"
        else:   self.usedIndoorModel = "yolov8l-oiv7.pt"
        if usedIndooModel != 'coco':
            self.indoorClasses = Labels().classes_ov7
        else: self.indoorClasses = Labels().classes_coco
        self.indoorModelPath = self.dirPath + "\model\indoor\\" + self.usedIndoorModel
        self.indoorModel = YOLO(self.indoorModelPath) 
        

        #---------  Outdoor --------#
        self.outdoorClasses = [Labels().classes_stairs, Labels().classes_pithole, Labels().classes_coco]

        self.outdoorModelPathStairs = self.dirPath + "\model\outdoor\Stairs.pt"
        self.outdoorModelStairs = YOLO(self.outdoorModelPathStairs)

        self.outdoorModelPathPithole = self.dirPath + "\model\outdoor\Pithole.pt"
        self.outdoorModelPithole = YOLO(self.outdoorModelPathPithole)

        self.outdoorModelPathWorld = self.dirPath + "\model\indoor\yolov8s.pt"
        self.outdoorModelWorld = YOLO(self.outdoorModelPathWorld)

        self.predicted_bboxes = {}

    #---------  Indoor  -----------#
    def detectIndoor(self, img):
        predictions = self.indoorModel(source=img, show=False, conf=.55)
        return predictions
    
    def getBBoxFromPredictionsIndoor(self, predictions):
        bboxes = predictions[0].boxes
        if bboxes and len(bboxes) > 0:
            i = 0
            self.predicted_bboxes.clear()
            for box in bboxes:
                x, y, w, h = box.xywh.cpu().numpy()[0]
                y = y + h
                self.predicted_bboxes['box{}'.format(i)] = {'xywh': [x.item(), y.item(), w.item(), h.item()], 
                                                            'className': self.indoorClasses[int(box.cls[0].cpu().numpy().item())]
                                                           }
                i +=1
            return self.predicted_bboxes
        return
    
    #---------  Outdoor  -----------#
    def detectOutdoor(self, img):
        stairsModelPredictions = self.outdoorModelStairs(source=img, show=False, conf=.75)
        pitholeModelPredictions = self.outdoorModelPithole(source=img, show=False, conf=.65)
        worldModelPredictions = self.outdoorModelWorld(source=img, show=False, conf=.55)
        return [stairsModelPredictions, pitholeModelPredictions, worldModelPredictions]
    
    def getBBoxFromPredictionsOutdoor(self, predictions):
        bboxes = [predictions[0][0].boxes, predictions[1][0].boxes, predictions[2][0].boxes]

        if bboxes and len(bboxes) > 0:
            i = 0
            j = 0
            self.predicted_bboxes.clear()
            for model in bboxes:
                for box in model:
                    if len(box.xywh.cpu().numpy()) > 0:
                        x, y, w, h = box.xywh.cpu().numpy()[0]
                        y = y + h
                        self.predicted_bboxes['box{}'.format(i)] = {'xywh': [x.item(), y.item(), w.item(), h.item()], 
                                                                    'className': self.outdoorClasses[j][int(box.cls[0].cpu().numpy().item())]
                                                                   }
                        i +=1
                j += 1
            print("predicted bboxes: ", self.predicted_bboxes)
            return self.predicted_bboxes
        return
        