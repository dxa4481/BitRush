"""
This script is meant to collect like terms using the other add multiply and divide script.
It does not keep track of input values, but rather, a variable for what the input could be.
"""


class Terms:

    """
    This class is a list of all terms that are summed together
    """
    __slots__ = ("termlist")

    def __init__(self,termlist=[]):
        self.termlist = termlist

    def add(self, terms):
        """
        This function tries combining like terms and if that fails adds a new term
        """
        for twoterm in terms.termlist:
            samename = False
            for oneterm in self.termlist:
                if(twoterm.name == oneterm.name):
                    samename = True
                    addornot = oneterm.add(twoterm)
                    if(not addornot):
                        self.termlist.append(twoterm)
                        break
            if(not samename):
                self.termlist.append(twoterm.clone())
        return self

    def multby2(self):
        """
        multiplies all terms by 2
        """
        for oneterm in self.termlist:
            oneterm.multby2()

    def divideby2(self):
        """
        Divides all terms by 2
        """
        for oneterm in self.termlist:
            oneterm.divideby2()

    def solve(self, dic):
        """
        takes a dictionary and solves the terms with the given values for each term
        """
        total = 0
        for oneterm in self.termlist:
            total += oneterm.solve(dic[oneterm.name])
        return total

    def __str__(self):
        stringout = ''
        for term in self.termlist:
            stringout += term.__str__() + ' + '
        return stringout

    def clone(self):
        """
        makes a copy of the term list
        """
        newterms = []
        for term in self.termlist:
            newterms.append(term.clone())
        return Terms(newterms)


class Term:
    __slots__ = ("name", "mult1", "div", "mult2")

    def __init__(self,name,mult1 = 1, div = 1, mult2 = 1):
        """
        takes a name, sets each mult and div to 1
        """
        self.name = name
        self.mult1 = mult1
        self.mult2 = mult2
        self.div = div

    def divideby2(self):
        """
        divides one term by 2
        """
# print("PREdivide!")
# print("mult1 ",self.mult1)
# print("div ",self.div)
# print("mult2 ",self.mult2)
        if(self.mult2 > 1):
            self.mult2 /= 2
        else:
            self.div *= 2
# print("POSTdivide!")
# print("mult1 ",self.mult1)
# print("div ",self.div)
# print("mult2 ",self.mult2)

    def multby2(self):
        """
        multiplies one term by 2
        """
# print("PREmultiply!")
# print("mult1 ",self.mult1)
# print("div ",self.div)
# print("mult2 ",self.mult2)
        if(self.div == self.mult2):
            self.div *= 2
            self.mult1 *= 2
            self.mult2 *= 2
        else:
            self.mult2 *= 2
# print("POSTmultiply!")
# print("mult1 ",self.mult1)
# print("div ",self.div)
# print("mult2 ",self.mult2)

    def solve(self, value):
        """
        takes a value and solves the one term for that value
        """
        value = (value * self.mult1) % 4294967296
        value = (value / self.div) % 4294967296
        value = (value * self.mult2) % 4294967296
        return value

    def add(self, term):
        """
        tries to combine terms, returns false if it can't
        """
        if(self.mult1 == term.mult1 and self.div == term.div and 1 == 2):
            self.mult2 += term.mult2
            return True
        return False

    def clone(self):
        """
        copies it's self
        """
        return Term(self.name, self.mult1, self.div, self.mult2)

    def __str__(self):
        stringout = '(((' + self.name + ' * ' + str(self.mult1) + ')'
        stringout += ' / ' + str(self.div) + ')'
        stringout += ' * ' + str(self.mult2) + ')'
        return stringout


def shiftleft(terms, shiftplaces):
    """
    shifts bits to the left by the amount shiftplaces
    """
    tempterms = deepcopy(terms)
    for i in range(shiftplaces):
        tempterms.multby2()
# print(bin(tempterms.solve({'x':7,'y':7})))
# print(tempterms.termlist[0].mult1)
# print(tempterms.termlist[0].div)
# print(tempterms.termlist[0].mult2)
# print(i)
# print(bin(asdf%4294967296))
    return tempterms


def shiftright(terms, shiftplaces):
    """
    shifts bits to the right by the amount shiftplaces
    """
    tempterms = deepcopy(terms)
    for i in range(shiftplaces):
# print('poop')
# print(bin(tempterms.solve({'x':7,'y':7})))
# print(tempterms.termlist[0].mult1)
# print(tempterms.termlist[0].div)
# print(tempterms.termlist[0].mult2)
        tempterms.divideby2()
# print('poop')
# print(bin(tempterms.solve({'x':7,'y':7})))
# print(tempterms.termlist[0].mult1)
# print(tempterms.termlist[0].div)
# print(tempterms.termlist[0].mult2)
    return tempterms


def setbit(terms, bit):
    """
    zeroes out all bits that aren't the one of interest
    """
    bitclone = deepcopy(terms)
    # print bitclone
    bitclone = shiftright(bitclone, bit)
    # print bitclone
    bitclone = shiftleft(bitclone, 31)
    bitclone = shiftright(bitclone, 31 - bit)
    # print(bin(bitclone.solve({'x':7,'y':7})))
    return bitclone


def deepcopy(terms):
    """
    calls clone and copies terms object
    """
    return terms.clone()


def andbits(terms1, terms2):
    """
    ands two terms together
    """
    terms3 = Terms()
    for i in range(31):
        bit1 = setbit(terms1, i)
        bit2 = setbit(terms2, i)
        bit1 = shiftleft(bit1, 30 - i)
        bit2 = shiftleft(bit2, 30 - i)
        # print ('bit1: ',bin(bit1.solve({'x': 7,'y':7})))
        # print ('bit2: ',bin(bit2.solve({'x': 7,'y':7})))
        bitsum = bit1.add(bit2)
        # print(bin(bitsum.solve({'x': 7,'y':7})))
        bitsum = setbit(bitsum, 31)
        print bitsum
        bitsum = shiftright(bitsum, 31 - i)
        terms3.add(bitsum)

    bit1 = setbit(terms1, 31)
    bit2 = setbit(terms2, 31)
    bit1 = shiftright(bit1, 1)
    bit2 = shiftright(bit2, 1)
    bitsum = bit1.add(bit2)
    bitsum = setbit(bitsum, 31)
    terms3.add(bitsum)
    return terms3
"""
Code below is for testing only
"""
term1 = Term('x')
term2 = Term('y')
terms1 = Terms([term1])
terms2 = Terms([term2])
# terms1 = setbit(terms1, 31)
# print terms1
terms1 = andbits(terms1, terms2)
# print((terms1.solve({'x': 7,'y':7})))
# print(bin(terms1.solve({'x':7,'y':7})))

# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# x0000000000000000000000000000000
# 0000000000000000000000000000000x
# 0x000000000000000000000000000000