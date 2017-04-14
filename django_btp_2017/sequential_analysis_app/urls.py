from django.conf.urls import url, include
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static

from . import views

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.homepage, name='homepage'),
    url(r'^uploads/', views.file_upload, name='file_upload'),
    url(r'^inter_stage_data/', views.view_inter_stage_data, name='view_inter_stage_data'),
]

if settings.DEBUG:
	urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_URL)
	urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    