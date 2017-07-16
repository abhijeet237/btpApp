from flask import Flask, request, render_template, redirect, url_for, send_from_directory
from werkzeug import secure_filename
import os
from running_R_from_python import run_R_script

__author__ = 'P Jishnu Jaykumar'
__contact__ = 'jishnu.jayakumar182@gmail.com' 


# Initialize the Flask application
app = Flask(__name__)

#This is the path of the app's root directory 
APP_ROOT = os.path.dirname(os.path.abspath(__file__))

# This is the path to the upload directory
app.config['UPLOAD_FOLDER'] = os.path.join(APP_ROOT, 'uploads/')

# This is the path to the main R-code 
app.config['R_SCRIPT_PATH'] = os.path.join(APP_ROOT, 'R-code/')
# This is the name of the main R-code 
app.config['R_SCRIPT_NAME'] = 'sequential_procedure.R'
# These are the extension that we are expecting to be uploaded
app.config['ALLOWED_EXTENSIONS'] = set(['xlsx', 'csv'])

# For a given file, return whether it's an allowed type or not
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in app.config['ALLOWED_EXTENSIONS']


# This route will show the homepage of the application
@app.route("/")
def homepage():
    return render_template('homepage.html', title='title')

# Route that will process the file upload
@app.route('/upload', methods=['POST','GET'])
def upload():
    # Get the name of the uploaded file
    file = request.files['file']
    # Check if the file is one of the allowed types/extensions
    if file and allowed_file(file.filename):
        # Make the filename safe, remove unsupported chars
        filename = secure_filename(file.filename)
        
        #if upload folder doesn't exist then create it

        if not os.path.isdir(app.config['UPLOAD_FOLDER']):
        	print os.mkdir(app.config['UPLOAD_FOLDER'])
        
        # Move the file form the temporal folder to
        # the upload folder we setup

        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        # Redirect the user to the uploaded_file route, which
        # will basicaly show on the browser the uploaded file
        return redirect(url_for('uploaded_file',
                                filename=filename))
    else:
    	return 'file type not supported.'

# This route is expecting a parameter containing the name
# of a file. Then it will locate that file on the upload
# directory and show it on the browser, so if the user uploads
# an image, that image is going to be show after the upload
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    input_file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    r_file_path = os.path.join(app.config['R_SCRIPT_PATH'], app.config['R_SCRIPT_NAME'])
    return run_R_script(r_file_path, input_file_path, '1000')
    '''
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)
	'''

if __name__ == "__main__":
	  app.run(
        debug=True
    )