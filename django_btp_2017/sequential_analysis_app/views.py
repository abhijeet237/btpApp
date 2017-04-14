from django.shortcuts import render
from django.conf import settings
from django.core.files.storage import FileSystemStorage
import numpy as np
from . import sequential_procedure as sp
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
RESULT_OBJ = None
# Create your views here.
def homepage(request):
	return render(request, 'sequential_analysis_app/homepage.html')

def file_upload(request):
    if request.method == 'POST' and request.FILES['input_file']:
    	budget=request.POST['budget']
        input_file = request.FILES['input_file']
        fs = FileSystemStorage()
        filename = fs.save(input_file.name, input_file)
        uploaded_file_url = fs.url(filename)
        num_iterations=5
        MEDIA_PATH = os.path.join(MEDIA_ROOT, input_file.name)
        result = sp.performSequentialAnalysisSimulation(MEDIA_PATH,budget,5, 2) #num_iterations=5, precicion upto 2 decimal places
        file_deleted=False
        RESULT_OBJ = result
        try:
        	os.remove(os.path.join(settings.MEDIA_ROOT, input_file.name))
        	file_deleted=True
        except Exception as e:
        	print "Exception when delete "+str(os.path.join(settings.MEDIA_ROOT, input_file.name))+","+str(e)

        '''try:
        	print sp.performSequentialAnalysis(uploaded_file_url,budget)
        except Exception, e:
        	result = str(e)
        '''

        return render(request, 'sequential_analysis_app/homepage.html', {
            'uploaded_file_url': uploaded_file_url,
            'result':result,
            'file_deleted':file_deleted 
        })
        
    return render(request, 'sequential_analysis_app/homepage.html')

def view_inter_stage_data(request):
    return render(request, 'sequential_analysis_app/view_inter_stage_data.html', {'result' : RESULT_OBJ})




