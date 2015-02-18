#~ for i in `seq 0 88`; 
#~ do hex=$(echo "obase=16; $i" | bc);
#~ hex=$(echo $hex | tr '[:upper:]' '[:lower:]');
#~ echo 0x$hex;
#~ gatttool -b FC:F8:A1:62:36:40  -t random  --char-read --handle=0x$hex; 
#~ done
#~ 
#~ gatttool -b FC:F8:A1:62:36:40  -t random  --char-read --handle=$(echo "obase=16; $i" | bc); 
import binascii
import struct
import subprocess
import time

def read_float(address, handle="0x000e"):
	command = [
			"gatttool", 
			"-b", address,
			"-t", "random",
			"--char-read", "--handle=%s" % handle]
	try:
		output = subprocess.check_output(command, timeout=2).decode().rstrip()
	except subprocess.TimeoutExpired:
		return "NA"
		
	data = output.split(":")[1].replace(' ', '')
	result = struct.unpack('<f', binascii.unhexlify(data))[0]
	return result



if __name__ == "__main__":
	try:
		t0 = time.time()
		while True:
			try:
				value = read_float("FC:F8:A1:62:36:40", handle="0x000e")
			except Exception as e:
				print(e)
				value = "NA"
				
			t = time.time() - t0
			print(t, value)
			time.sleep(1)
		
	except KeyboardInterrupt:
		pass
		
		
