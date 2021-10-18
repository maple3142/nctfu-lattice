from Crypto.Util.number import *

flag = b"FLAG{easy_copp3rsmith_c0ppersmith_coppersm1th}"

p = getPrime(512)
q = getPrime(512)
n = p * q
e = 3
m = bytes_to_long(flag)
c = power_mod(m, e, n)

Z = Zmod(n)
P = PolynomialRing(Z, "x")
x = P.gen()
a = bytes_to_long(b"FLAG{" + b"\0" * 40 + b"}")
f = (a + x * 2 ^ 8) ^ 3 - c
r = f.monic().small_roots(epsilon=0.03, beta=1.0, X=2 ^ 319)[0]
print(long_to_bytes(r))
