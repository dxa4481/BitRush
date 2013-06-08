class Term:
    __slots__=("name","mult1","div","mult2")

    def __init__(self,name,mult1=1,mult2=1,div=1):
        self.name = name
        self.mult1=mult1
        self.mult2=mult2
        self.div=div
    def devideby2(self):
        if(self.mult1>self.div and self.mult2>1):
            self.mult2/=2
        else:
            self.div*=2
            
    def multby2(self):
        if(self.div==self.mult2 or self.mult1==self.mult2):
            self.mult1*=2
        else:
            self.mult2*=2

    def solve(self,value):
        value=(value*self.mult1)%4294967296
        value=(value/self.div)%4294967296
        value=(value*self.mult2)%4294967296
        return value

    def __str__(self):
        stringout = '((('+self.name+' * '+str(self.mult1) + ')'
        stringout+= ' / ' + str(self.div) + ')'
        stringout+= ' * ' + str(self.mult2) + ')'
        return stringout




def shiftleft(term,shiftplaces):
    for i in range(shiftplaces):
        term.multby2()

def shiftright(term,shiftplaces):
    for i in range(shiftplaces):
        term.devideby2()





term1=Term('x')
term2=Term('x')
shiftleft(term1,20)
shiftright(term1,21)
shiftleft(term1,14)
shiftleft(term2,7)
shiftright(term2,1)
shiftleft(term2,20)

print(term1.solve(20))
print(term2.solve(20))

