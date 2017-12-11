import numpy as np
import cv2

plate_cascade = cv2.CascadeClassifier('plate_cascade.xml')
car_cascade = cv2.CascadeClassifier('car_cascade.xml')

cap = cv2.VideoCapture(1)
#cap = cv2.VideoCapture('plate004.avi')

while 1:
    ret, img = cap.read()
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    plates = plate_cascade.detectMultiScale(gray, 1.5, 5)
    cars   = car_cascade.detectMultiScale(gray, 1.5, 5)
    
    for (x,y,w,h) in plates:
        cv2.rectangle(img,(x,y),(x+w,y+h),(255,255,0),2)
        subImg = img[y:y+h,x:x+w].copy()
        blur = cv2.GaussianBlur(subImg,(23,23),30)
        img[y:y+blur.shape[0], x:x+blur.shape[1]] = blur
        

	for (x,y,w,h) in cars:
		cv2.rectangle(img,(x,y),(x+w,y+h),(0,255,0),2)

    cv2.imshow('img',img) #img
    k = cv2.waitKey(30) & 0xff
    if k == 27 or k == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
