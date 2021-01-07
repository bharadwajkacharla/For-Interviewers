import pandas as pd
import numpy as np
from flask import Flask, request, jsonify, render_template
import pickle
import csv

app = Flask(__name__)
model = pickle.load(open('model1.pkl','rb'))

@app.route('/')
def home():
    return render_template('index2.html')

@app.route('/predict',methods=['GET','POST'])
def predict():
    '''
    For rendering results on HTML GUI
    '''
    
    if request.method == 'POST':
        f = request.form['csvfile']
        with open(f) as file:
            csvfile = pd.read_csv(file)
            commentsList = csvfile.values
        prediction = model.predict(commentsList)
    
    if prediction==0:
        op = 'Customer will not buy'
    elif prediction==1:
        op = 'Customer will buy'

    return render_template('data1.html', prediction_text=op)



if __name__ == "__main__":
    app.run(debug=True)
