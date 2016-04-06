from django.db import models

class Key(models.Model):
	token = models.CharField(max_length = 4, unique=True)
	is_used = models.BooleanField(default = False)
	
	def set_used(self):
		if self.is_used:
			return False
		else:
			self.is_used = True
			self.save()
			return True
	
	def __str__(self):
		if self.is_used:
			return self.token + ' (used)'
		else:
			return self.token
