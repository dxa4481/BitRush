def devideby2(num):
    return((num/2)%4294967296)
def multby2(num):
    return((num*2)%4294967296)
def add(num1,num2):
    return((num1+num2)%4294967296)




def shiftleft(num,shiftplaces):
    for i in range(shiftplaces):
        num = multby2(num)
    return num

def shiftright(num,shiftplaces):
    for i in range(shiftplaces):
        num = devideby2(num)
    return num

def rotateright(num,rotateplaces):
    shifted=shiftright(num,rotateplaces)
    mask=add(shiftleft(2,rotateplaces-1),-1)
    masked=andbits(num,mask)
    shiftedmask=shiftleft(masked,31-rotateplaces)
    addon=add(shiftedmask,shifted)
    return addon
def setbit(num,bit):
    """ set bit makes all numbers 0 that aren't the bit of interest
    bits are numbered like this 31...3,2,1,0
    """
    num=shiftright(num,bit)
    num=shiftleft(num,31)
    num=shiftright(num,31-bit)
    return num

def andbits(num1,num2):
    thingstoadd=[]
    for i in range(31):
        bit1=setbit(num1,i)
        bit2=setbit(num2,i)
        bit1=shiftleft(bit1,30-i)
        bit2=shiftleft(bit2,30-i)
        bitsum=add(bit1,bit2)
        bitsum=setbit(bitsum,31)
        bitsum=shiftright(bitsum,31-i)
        thingstoadd.append(bitsum)
    bit1=setbit(num1,31)
    bit2=setbit(num2,31)
    bit1=shiftright(bit1,1)
    bit2=shiftright(bit2,1)
    bitsum=add(bit1,bit2)
    bitsum=setbit(bitsum,31)
    thingstoadd.append(bitsum)
    return sum(thingstoadd)

def xorbits(num1,num2):
    thingstoadd=[]
    for i in range(31):
        bit1=setbit(num1,i)
        bit2=setbit(num2,i)
        bit1=shiftleft(bit1,31-i)
        bit2=shiftleft(bit2,31-i)
        bitsum=add(bit1,bit2)
        bitsum=shiftright(bitsum,31-i)
        thingstoadd.append(bitsum)
    return sum(thingstoadd)

print(shiftleft(shiftright(shiftleft(17,20),21),14))
print(shiftleft(shiftright(shiftleft(17,20),21),14))+(shiftleft(shiftright(shiftleft(12,7),1),20))

