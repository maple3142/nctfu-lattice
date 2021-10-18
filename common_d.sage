# https://www.ijcsi.org/papers/IJCSI-9-2-1-311-314.pdf

from Crypto.Util.number import getPrime

d = getPrime(500)


def getpub():
    p = getPrime(512)
    q = getPrime(512)
    e = inverse_mod(d, (p - 1) * (q - 1))
    return p * q, e


R = 56
pubkeys = [getpub() for _ in range(R)]

M = isqrt(max(pub[0] for pub in pubkeys))
B = matrix(R + 1, R + 1)
B[0, 0] = M
for i in range(R):
    B[0, i + 1] = pubkeys[i][1]
    B[i + 1, i + 1] = pubkeys[i][0]
for row in B.LLL(delta=0.9999999):
    if row[0] % d == 0:
        print(row)
