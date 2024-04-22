import numpy as np

def _2s_complement(data,nbits):
	if(data < 0):
		return data + 2**(nbits+1)
	else:
		return data

sin_filename = '../memory_content/sin.mem'
cos_filename = '../memory_content/cos.mem'

nbits = 15 # decimal bits
nbits_angle = 12 # used for the memory length (address_width)

angle_vector = np.linspace(0,2*np.pi,2**nbits_angle, endpoint=False)

# sine signal
sine_signal = np.sin(angle_vector) * 0.99
sine_signal_q = (sine_signal * 2**nbits).astype(int)

with open(sin_filename, "w") as sine_file:
	for data in sine_signal_q:
		sine_file.write(f'{_2s_complement(data,nbits):x} ')

# cosine signal
cosine_signal = np.cos(angle_vector) * 0.99
cosine_signal_q = (cosine_signal * 2**nbits).astype(int)

with open(cos_filename, "w") as cosine_file:
	for data in cosine_signal_q:
		cosine_file.write(f'{_2s_complement(data,nbits):x} ')

