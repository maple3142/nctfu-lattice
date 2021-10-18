def wiener(e, n, phi_approx=None):
    if not phi_approx:
        phi_approx = n
    cf = continued_fraction(e / phi_approx)
    for c in cf.convergents():
        k = c.numer()
        dg = c.denom()
        if k > 0 and (e * dg - 1) % k == 0:
            phi = (e * dg - 1) // k
            # (x-p)(x-q)=x^2-(p+q)+pq=x^2-(n-phi+1)+n
            b = -(n - phi + 1)
            D = b ** 2 - 4 * n
            if D >= 0 and is_square(D):
                p = (-b + isqrt(D)) // 2
                if n % p == 0:
                    return p, n // p


def cf2conv(cf):
    n, d = 0, 1
    for x in cf[::-1]:
        # 1/(x+n/d)=1/((xd+n)/d)=d/(xd+n)
        n, d = d, x * d + n
    return d, n


def cf2convs(cf):
    return [cf2conv(cf[:i]) for i in range(1, len(cf) + 1)]


def cf2convs_wiener(cf):
    # https://www.cits.ruhr-uni-bochum.de/imperia/md/content/may/krypto2ss08/shortsecretexponents.pdf Section 3
    for i in range(1, len(cf) + 1):
        if i % 2 == 0:
            yield cf2conv(cf[:i])
        else:
            yield cf2conv(cf[: i - 1] + [cf[i - 1] + 1])


def wiener2(e, n, phi_approx=None):
    if not phi_approx:
        phi_approx = n
    cf = continued_fraction(e / phi_approx)
    for (k, dg) in cf2convs_wiener(cf.quotients()):
        if k == 0:
            continue
        phi = (e * dg) // k  # assumes g < k
        b = -(n - phi + 1)
        D = b ** 2 - 4 * n
        if D >= 0 and is_square(D):
            # If you just want d
            # g = e * dg - k * phi
            # return dg // g
            phi = (e * dg - 1) // k
            p = (-b + isqrt(D)) // 2
            if n % p == 0:
                return p, n // p


p = random_prime(2 ^ 512)
q = random_prime(2 ^ 512)
n = p * q
ub = ceil(n ^ (260 / 1000))
d = next_prime(ub)
e = inverse_mod(d, (p - 1) * (q - 1))

print("wiener")
print(wiener(e, n))
print(wiener2(e, n))
print()


def lattice_reduction_2(u, v):
    while True:
        if v * v < u * u:
            u, v = v, u
        m = (u * v) // (u * u)
        if m == 0:
            return u, v
        v = v - m * u


print("2d lattice")
u = vector([e, isqrt(n)])
v = vector([n, 0])
for v in lattice_reduction_2(u, v):
    dd = abs(v[1] // isqrt(n))
    if power_mod(2, e * dd, n) == 2:
        print(f"{dd = }")
print()

print("coppersmith")
P = PolynomialRing(Zmod(e), "k,s")
k, s = P.gens()
f = 1 + k * (n - s)
load("coppersmith.sage")
print(small_roots(f, (ub, 2 ^ 513), m=8, d=4))
print()
