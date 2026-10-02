class Test {
    public static void main(String[] args) {
        int n = 6, f = 1, k = 2;
        int p = k ** n;
        int q = n % 4 + (n - n);
        while (n > 1) {
            f = f * n;
            n = n - 1;
        }
        int r = f / 3 + f * 2;
        int s = f / 3 + f * 2;
        int t = -f + p * 0 + q;
        // a loop with a branch inside
        int j = 0;
        while (j < 4) {
            if (j % 2 == 0)
                System.out.println(j * j);
            else
                System.out.println(f - j);
            j = j + 1;
        }
        System.out.println(r + s);
        System.out.println(t);
        System.out.println(p);
    }
}
