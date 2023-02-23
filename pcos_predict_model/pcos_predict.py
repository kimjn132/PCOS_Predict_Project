"""
Create on 2023-02-22
author : 노현석
Description : Flutter와 Python의 AI의 예측값 보내기
"""

from flask import Flask, jsonify, render_template, request
import joblib

app = Flask(__name__)

@app.route("/pcospredict")
def pcos():
    height = float(request.args.get("height"))
    weight = float(request.args.get("weight"))
    waist = float(request.args.get("waist"))
    hair_growthYN = float(request.args.get("hair_growthYN"))
    skin_darkeningYN = float(request.args.get("skin_darkeningYN"))
    weight_gainYN = float(request.args.get("weight_gainYN"))
    fastfoodYN = float(request.args.get("fastfoodYN"))
    pimmplesYN = float(request.args.get("pimmplesYN"))

    BMI = weight/ (height/100)**2
    print(BMI)
    clf = joblib.load("PCOS_final_898.h5")
    pre = clf.predict_proba([[hair_growthYN,skin_darkeningYN,weight_gainYN,BMI,waist,fastfoodYN,pimmplesYN]])
    
    #return jsonify({"result":round(pre[0][1]*100,2)})
    return jsonify({"result":round(pre[0][1]*100,2)})

if __name__ == "__main__":
    app.run(host="127.0.0.1", port = 5000, debug=True)