from django.http import HttpResponse
from django.shortcuts import render
from keys.models import *
import random
import string

def get_count_free_keys():
	return 62 ** 4 - Key.objects.all().count()

def index(request):
	return render(request, 'index.html', {})



def set_key_is_used(request, code):
	if request.method != 'POST':
		return HttpResponse('METHOD NOT ALLOWED', status=405)
	try:
		key = Key.objects.get(token = code)
		if key.set_used():
			output = 'OK\n'
		else:
			output = 'FAIL: Key already is used\n'
		return HttpResponse(output)
	except Exception as e:
		return HttpResponse(str(e))



def get_new_key(request):
	if request.method != 'GET':
		return HttpResponse('METHOD NOT ALLOWED', status=405)
	if get_count_free_keys == 0:
		return HttpResponse('0 FREE KEYS\n')
	success = False
	while(not success):
		code = ''.join(random.choice(string.ascii_uppercase + string.ascii_lowercase + string.digits) for x in range(4))
		success = True
		try:
			key = Key.objects.create(token = code)
		except Exception:
			success = False
	return HttpResponse(code)



def check_key(request, code):
	if request.method != 'GET':
		return HttpResponse('METHOD NOT ALLOWED', status=405)
	try:
		key = Key.objects.get(token = code)
		if key.is_used:
			return HttpResponse('USED\n')
		else:
			return HttpResponse('NOT USED\n')
	except Exception as e:
		return HttpResponse(str(e))



def get_key_stat(request):
	if request.method != 'GET':
		return HttpResponse('METHOD NOT ALLOWED', status=405)
	return HttpResponse(str(get_count_free_keys()) + '\n')



