from Crypto.Util.number import *

p = getPrime(512)
q = getPrime(512)
n = p * q

bp = p >> 212
bq = q >> 212

# P = PolynomialRing(Zmod(n), "x,y")
# x, y = P.gens()
# f = (bp * 2 ^ 212 + x) * (bq * 2 ^ 212 + y)
# print(f(p % (2 ^ 212), q % (2 ^ 212)))
# load("coppersmith.sage")
# x, y = small_roots(f, (2 ^ 212, 2 ^ 212), m=3, d=4)[0]
# print(p, (bp * 2 ^ 212 + x))
# print(q, (bq * 2 ^ 212 + y))

# P = PolynomialRing(Zmod(n), "x")
# x = P.gen()
# f = bp * 2 ^ 212 + x
# print(f(p % (2 ^ 212)) == p)
# x = f.small_roots(epsilon=0.05, beta=0.5, X=2 ^ 212)[0]
# print(p, bp * 2 ^ 212 + x)

P = PolynomialRing(Zmod(n), 1, "x")
x = P.gen()
f = bp * 2 ^ 212 + x
load("coppersmith.sage")
x = small_roots(f, (2 ^ 212,), m=4, d=8)[0][0]
print(p, f(x))
