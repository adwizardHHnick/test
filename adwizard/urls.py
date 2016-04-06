from django.conf.urls import url
from django.contrib import admin
from adwizard import views

admin.autodiscover()

urlpatterns = [
	url(r'^$', views.index),
    url(r'^admin/', admin.site.urls),
    url(r'^key/new/?$', views.get_new_key),
    url(r'^key/remain/?$', views.get_key_stat),
    url(r'^key/(?P<code>[0-9A-Za-z]{4})/?$', views.check_key),
    url(r'^key/(?P<code>[0-9A-Za-z]{4})/set_used/?$', views.set_key_is_used)
]
