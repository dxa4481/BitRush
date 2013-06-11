from copy import deepcopy
class Terms:
    __slots__=("termlist")

    def __init__(self,termlist=[]):
        self.termlist=termlist
    def add(self,terms):
        for twoterm in terms.termlist:
            for oneterm in self.termlist:
                addornot=False
                if(twoterm.name==oneterm.name):
                    addornot=oneterm.add(twoterm)
            if(not addornot):
                self.termlist.append(twoterm)
        return self
    def multby2(self):
        for oneterm in self.termlist:
            oneterm.multby2()
    def devideby2(self):
        for oneterm in self.termlist:
            oneterm.devideby2()
    def solve(self,dic):
        total=0
        for oneterm in self.termlist:
            total+=oneterm.solve(dic[oneterm.name])
        return total
    def __str__(self):
        stringout=''
        for term in self.termlist:
            stringout+=term.__str__()+' + '
        return stringout        
class Term:
    __slots__=("name","mult1","div","mult2")

    def __init__(self,name,mult1=1,mult2=1,div=1):
        self.name = name
        self.mult1=mult1
        self.mult2=mult2
        self.div=div
    def devideby2(self):
        if(self.mult2>1 and self.mult2<(self.mult1+self.div)):
            self.mult2/=2
        else:
            self.div*=2
            
            
            
    def multby2(self):
        if((self.mult1+self.div)>self.mult2):
            self.mult2*=2
        else:
            self.div*=2
            self.mult1*=2
            self.mult2*=2

    def solve(self,value):
        value=(value*self.mult1)%4294967296
        value=(value/self.div)%4294967296
        value=(value*self.mult2)%4294967296
        return value
    def add(self,term):
        if(self.mult1==term.mult1 and self.div==term.div):
            self.mult2+=term.mult2
            return True
        return False
    def __str__(self):
        stringout = '((('+self.name+' * '+str(self.mult1) + ')'
        stringout+= ' / ' + str(self.div) + ')'
        stringout+= ' * ' + str(self.mult2) + ')'
        return stringout




def shiftleft(terms,shiftplaces):
    tempterms=deepcopy(terms)
    asdf=0b11
    for i in range(shiftplaces):
        asdf*=2
        tempterms.multby2()
##        print(bin(tempterms.solve({'x':7,'y':7})))
##        print(tempterms.termlist[0].mult1)
##        print(tempterms.termlist[0].div)
##        print(tempterms.termlist[0].mult2)
##        print(i)
##        print(bin(asdf%4294967296))
        
    return tempterms

def shiftright(terms,shiftplaces):
    tempterms=deepcopy(terms)
    for i in range(shiftplaces):
##        print(bin(tempterms.solve({'x':7,'y':7})))
##        print(tempterms.termlist[0].mult1)
##        print(tempterms.termlist[0].div)
##        print(tempterms.termlist[0].mult2)
        tempterms.devideby2()
##        
##        print(tempterms.termlist[0].mult1)
##        print(tempterms.termlist[0].div)
##        print(tempterms.termlist[0].mult2)
    return tempterms

def setbit(terms,bit):
    bitclone=deepcopy(terms)
   
    bitclone=shiftright(bitclone,bit)
      


##    print(bitclone.termlist[0].mult1)
##    print(bitclone.termlist[0].div)
##    print(bitclone.termlist[0].mult2)
##    print(bin(bitclone.solve({'x':7,'y':7})))
##    print('~')

##    print(bitclone.termlist[0].mult1)
##    print(bitclone.termlist[0].div)
##    print(bitclone.termlist[0].mult2)
##    print(bin(bitclone.solve({'x':7,'y':7})))
##    print('~')

##    print(bitclone.termlist[0].mult1)
##    print(bitclone.termlist[0].div)
##    print(bitclone.termlist[0].mult2)
    
##    print('~')
    
    bitclone=shiftleft(bitclone,31)
##    print(bin(bitclone.solve({'x':7,'y':7})))   
    bitclone=shiftright(bitclone,31-bit)
##    print(bin(bitclone.solve({'x':7,'y':7})))    
    return bitclone

def andbits(terms1,terms2):
    thingstoadd=[]
    for i in range(31):
        bit1=setbit(terms1,i)
        bit2=setbit(terms2,i)
        bit1=shiftleft(bit1,30-i)
        bit2=shiftleft(bit2,30-i)
        bitsum=bit1.add(bit2)
        bitsum=setbit(bitsum,31)
        bitsum=shiftright(bitsum,31-i)
        thingstoadd.append(bitsum)
    bit1=setbit(terms1,31)
    bit2=setbit(terms2,31)
    bit1=shiftright(bit1,1)
    bit2=shiftright(bit2,1)
    bitsum=bit1.add(bit2)
    bitsum=setbit(bitsum,31)
    thingstoadd.append(bitsum)
    tempterm=thingstoadd[0]
    tempbool=True
    for term in thingstoadd:
        if(tempbool):
            tempbool=False
        else:
            tempterm.add(term)
    return tempterm


term1=Term('x')
term2=Term('y')
"""
term1=shiftleft(term1,20)
term1=shiftright(term1,21)
term1=shiftleft(term1,14)
term2=shiftleft(term2,7)
term2=shiftright(term2,1)
term2=shiftleft(term2,20)
"""

terms1=Terms([term1])
terms2=Terms([term2])
#a=1
#terms1=shiftright(terms1,a)
#terms1=shiftleft(terms1,31)
#terms1=shiftright(terms1,31-a)


terms1=setbit(terms1,0)
print(terms1.solve({'x':7,'y':7}))

print(len(terms1.termlist))


