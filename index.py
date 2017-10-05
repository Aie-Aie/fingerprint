# author: Ailen Aspe

from flask import Flask, jsonify, request
from db import DBconnection
from flask_httpauth import HTTPBasicAuth
from flask import render_template, redirect, url_for, session, flash
import sys, flask, os
import warnings
from flask.exthook import ExtDeprecationWarning

app = Flask(__name__)
auth = HTTPBasicAuth()


def spcall(query, param, commit=False):
    try:
        dbo = DBconnection()
        cursor = dbo.getcursor()
        cursor.callproc(query, param)
        res = cursor.fetchall()

        if commit:
            dbo.dbcommit()
        return res

    except:
        res = [("Error: " + str(sys.exc_info()[0]) + " " + str(sys.exc_info()[1]),)]

    return res


@app.route('/')
def index():
    return "Hello to COE PROJECT. Aja!"

#view events given an id
@app.route('/events/<string:data>', methods=['GET'])
def viewevents(data):
    res= spcall('getevents', (data, ), True)
    if 'Error' in str(res[0][0]):
        return jsonify({'status':'error', 'message':res[0][0]})

    recs=[]

    for r in res:
        recs.append({'studid':r[0], 'event':r[1], 'eventdate':r[2], 'signin':r[3], 'signout':r[4]})
    return jsonify({'status':'ok', 'entries': recs, 'count': len(recs)})


#view student data given an id
@app.route('/studentdata/<string:data>', methods=['GET'])
def viewstuddata(data):
    res=spcall('getstudentdata', (data,), True)
    if 'Error' in str(res[0][0]):
        return jsonify({'status':'error', 'message':res[0][0]})
    recs=[]

    for r in res:
        recs.append({'studid':r[0], 'firstname':r[1], 'lastname':r[2], 'course':r[3]})
    return jsonify({'status':'ok', 'entries':recs, 'count':len(recs)})

#add student


@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    # resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get ('Origin')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging

    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp


if __name__ == '__main__':
    app.run(debug=True)
