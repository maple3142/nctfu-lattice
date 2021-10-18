a = 0x876387638763
b = 0xDEADBEEF
m = 2 ** 64
s = 0x314231423142
trunc = 2 ** 48
n = 5  # number of states


def lcg():
    global s
    s = (a * s + b) % m
    return s


xs = [lcg() for _ in range(n)]  # xs, actual states
zs = [x % trunc for x in xs]  # zs, truncated lower bits
ys = [x - z for x, z in zip(xs, zs)]  # ys, remaining upper bits, known to attacker
assert all(y + z == x for x, y, z in zip(xs, ys, zs))

ks = []

for z1, z2, y1, y2 in zip(zs, zs[1:], ys, ys[1:]):
    rhs = y2 - a * y1 - b
    lhs = z1 * a - z2
    assert (rhs - lhs) % m == 0
    ks.append((rhs - lhs) // m)

M = Matrix(ZZ, n * 2 - 1, n - 1 + n)
for i in range(n - 1):
    M[i, i] = a
    M[i + 1, i] = -1
    M[i, i + n - 1] = 1
    M[n + i, i] = m
M[n - 1, -1] = 1
print(M)
print(M.dimensions())

print("expected solution", vector(zs + ks) * M)

ub = []

for y1, y2 in zip(ys, ys[1:]):
    ub.append(y2 - a * y1 - b)

lb = list(ub)

lb += [0] * n
ub += [trunc] * n

print("lb", lb)
print("ub", ub)

load(
    "solver.sage"
)  # https://raw.githubusercontent.com/rkm0959/Inequality_Solving_with_CVP/main/solver.sage

result, applied_weights, fin = solve(M, lb, ub)
assert vector(fin[:n]) == vector(zs), "failed to find zs"
print(fin[:n])
