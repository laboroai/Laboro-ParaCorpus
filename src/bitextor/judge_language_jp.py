def isjpchar(char):
	if char>=u'\u3040' and char<=u'\u30ff':
		return True,True
	elif char>=u'\u31f0' and char<=u'\u31ff':
		return True,False
	elif char>=u'\u3400' and char<=u'\u34bf':
		return True,False
	elif char>=u'\u4e00' and char<=u'\u9fff':
		return True,False
	elif char>=u'\uf900' and char<=u'\ufaff':
		return True,False
	else:
		return False,False

def iskana(char):
	if char>=u'\u3040' and char<=u'\u30ff':
		return True
	else:
		return False

def judge(line):
    '''
    judge if hiragana is more than 5% (not Chinese)
    judge if japanese character is more than 70% (not other language)
    delete control characters
    '''

    char_counter = 0
    jp_counter = 0
    kana_counter = 0

    for char in line:
        char_counter += 1
        isjp,iskn = isjpchar(char)
        if isjp:
            jp_counter += 1
            if iskn:
                kana_counter += 1

    if float(jp_counter)/float(char_counter)>=0.1:
        if float(kana_counter)/float(char_counter)>=0.01:
            return True,line

    return False,''
