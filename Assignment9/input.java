class Main {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;
        int c = 2 * 3 + a * 1;
        int d = b ** 2;
        int sum = 0, i = 1;
        while (i <= 5) {
            sum = sum + i * 2;
            i = i + 1;
        }
        int x1 = sum + i;
        int x2 = sum + i;
        int e = sum * 2;
        if (a < b) {
            System.out.println("b is greater");
        } else {
            System.out.println("a is greater");
        }
        System.out.println(c + d);
    }
}
