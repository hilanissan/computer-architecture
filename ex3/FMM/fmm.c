#include "fmm.h"

// Slow fmm :)
void fmm(int n, int* m1, int* m2, int* result) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            result[i * n + j] = 0;  // result[i][j] = 0
            for (int k = 0; k < n; k++) 
                result[i * n + j] += m1[i * n + k] * m2[k * n + j];  // result[i][j] += m1[i][k] * m2[k][j]
        }
    }
    //  int r;
    // for (int k = 0; k < n; k++) {
    //     for (int i = 0; i < n; i++) {
    //         r = m1[i * n + k];
    //         // result[i * n + j] = 0;  // result[i][j] = 0
    //         for (int j = 0; j < n; j++) 
    //             result[i * n + j] += r * m2[k * n + j];  // result[i][j] += m1[i][k] * m2[k][j]
    //     }
    }
    void add(int n, int *A, int *B, int *C) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            *(C + i * n + j) = *(A + i * n + j) + *(B + i * n + j);
        }
    }
}

void subtract(int n, int *A, int *B, int *C) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            *(C + i * n + j) = *(A + i * n + j) - *(B + i * n + j);
        }
    }
}

    void strassen_multiply(int n, int* m1, int* m2, int* result) {
    if (n == 1) {
        *result = (*m1) * (*m2);
        return;
    }

    int size = n / 2;

    int *A11 = m1;
    int *A12 = m1 + size;
    int *A21 = m1 + size * n;
    int *A22 = m1 + size * n + size;

    int *B11 = m2;
    int *B12 = m2 + size;
    int *B21 = m2 + size * n;
    int *B22 = m2 + size * n + size;

    int *C11 = result;
    int *C12 = result + size;
    int *C21 = result + size * n;
    int *C22 = result + size * n + size;

    int M1[size * size], M2[size * size], M3[size * size], M4[size * size], M5[size * size], M6[size * size], M7[size * size];
    int temp1[size * size], temp2[size * size];

    // Populate M1
    subtract(size, B12, B22, temp1);
    strassen_multiply(size, A11, temp1, M1);

    // Populate M2
    add(size, A11, A12, temp1);
    strassen_multiply(size, temp1, B22, M2);

    // Populate M3
    add(size, A21, A22, temp1);
    strassen_multiply(size, temp1, B11, M3);

    // Populate M4
    subtract(size, B21, B11, temp1);
    strassen_multiply(size, A22, temp1, M4);

    // Populate M5
    add(size, A11, A22, temp1);
    add(size, B11, B22, temp2);
    strassen_multiply(size, temp1, temp2, M5);

    // Populate M6
    subtract(size, A12, A22, temp1);
    add(size, B21, B22, temp2);
    strassen_multiply(size, temp1, temp2, M6);

    // Populate M7
    subtract(size, A11, A21, temp1);
    add(size, B11, B12, temp2);
    strassen_multiply(size, temp1, temp2, M7);

    // Compute C11
    add(size, M5, M4, temp1);
    subtract(size, temp1, M2, temp2);
    add(size, temp2, M6, C11);

    // Compute C12
    add(size, M1, M2, C12);

    // Compute C21
    add(size, M3, M4, C21);

    // Compute C22
    add(size, M5, M1, temp1);
    subtract(size, temp1, M3, temp2);
    subtract(size, temp2, M7, C22);

    // Combine C11, C12, C21, C22 into the result using int* pointers
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            *(result + i * n + j) = C11[i * size + j];
            *(result + i * n + j + size) = C12[i * size + j];
            *(result + (i + size) * n + j) = C21[i * size + j];
            *(result + (i + size) * n + j + size) = C22[i * size + j];
        }
    }
}







