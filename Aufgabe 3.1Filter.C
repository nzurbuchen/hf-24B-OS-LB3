// filter.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1024

int main() {
    char line[MAX_LINE];
    int total = 0, passed = 0;

    // Header-Zeile übernehmen
    if (fgets(line, sizeof(line), stdin)) {
        printf("%s", line);
    }

    while (fgets(line, sizeof(line), stdin)) {
        total++;
        char *copy = strdup(line);
        char *token = strtok(copy, ","); // ID
        token = strtok(NULL, ",");       // Name
        token = strtok(NULL, ",");       // Wert

        if (token) {
            double value = atof(token);
            if (value >= 0 && value <= 100) {
                printf("%s", line);
                passed++;
            }
        }

        free(copy);
    }

    fprintf(stderr, "Verarbeitet: %d Zeilen\n", total);
    fprintf(stderr, "Gefiltert:   %d Zeilen (Wert zwischen 0 und 100)\n", passed);

    return 0;
}
