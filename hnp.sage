n = 4
p = random_prime(2 ^ 256)
a = randint(1, p)
t = vector([randint(1, p) for _ in range(n)])
u = (a * t) % p
uu = vector([x + randint(-isqrt(p), isqrt(p)) for x in u])

B = matrix.identity(n) * p
B = B.augment(vector([0] * n))
B = B.stack(vector(list(t) + [1 / p]))


def Babai_closest_vector(B, target):
    # Babai's Nearest Plane algorithm
    M = B.LLL()
    G = M.gram_schmidt()[0]
    small = target
    for i in reversed(range(M.nrows())):
        c = ((small * G[i]) / (G[i] * G[i])).round()
        small -= M[i] * c
    return target - small


r = Babai_closest_vector(B, vector(QQ, list(uu) + [1 / 2]))
print(a, (r[0] / t[0]) % p)
print(a, r[-1] * p)
