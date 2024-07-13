from flask import Flask, request, jsonify
import base64
from PIL import Image
from io import BytesIO
import cv2
import numpy as np
from detection import Detection 

app = Flask(__name__)
detection_class = Detection(usedIndooModel="coco")

# Indoor Route
@app.route('/api/indoor', methods = ['POST'])
def runIndoorModel():
    # Image received in the form of base64 string
    input_base64 = request.get_data()
    if not input_base64:
        print('error Missing image')
        return jsonify({'error': 'Missing image data'}), 400
    
    try:
        img_decoded = base64.b64decode(input_base64)
        
    except Exception as e:
        print('error decoding message')
        return jsonify({'error': 'Invalid base64 - {}'.format(str(e))}), 400
    
    # Image is saved in bytes buffer
    img = Image.open(BytesIO(img_decoded))

    # Image is converted to numpy array the cv format
    cv_img = np.array(img)
    img_rotated = cv2.rotate(cv_img, cv2.ROTATE_90_CLOCKWISE) # Image returned from phones needs to be rotated 90 degrees
    
    # Get model resulst
    predictions = detection_class.detectIndoor(img=img_rotated)

    #Get BBoxes
    bboxs = detection_class.getBBoxFromPredictionsIndoor(predictions=predictions)
    
    if bboxs:
        return jsonify(bboxs)
    return jsonify('no predictions')



# Outdoor Route
@app.route('/api/outdoor', methods = ['POST'])
def runOutdoorModel():
    # Image received in the form of base64 string
    input_base64 = request.get_data()
    if not input_base64:
        print('error Missing image')
        return jsonify({'error': 'Missing image data'}), 400
    
    try:
        img_decoded = base64.b64decode(input_base64)
        
    except Exception as e:
        print('error decoding message')
        return jsonify({'error': 'Invalid base64 - {}'.format(str(e))}), 400
    
    # Image is saved in bytes buffer
    img = Image.open(BytesIO(img_decoded))

    # Image is converted to numpy array the cv format
    cv_img = np.array(img)
    img_rotated = cv2.rotate(cv_img, cv2.ROTATE_90_CLOCKWISE) # Image returned from phones needs to be rotated 90 degrees
    
    # Get model resulst
    predictions = detection_class.detectOutdoor(img=img_rotated)

    #Get BBoxes
    bboxs = detection_class.getBBoxFromPredictionsOutdoor(predictions=predictions)
    
    if bboxs:
        return jsonify(bboxs)
    return jsonify('no predictions')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)