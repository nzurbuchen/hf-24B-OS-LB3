// log_generator.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

const char *levels[] = {"INFO", "WARNING", "ERROR"};
const char *messages[] = {
    "System start complete",
    "Low memory warning",
    "User login successful",
    "Disk space critical",
    "Configuration loaded",
    "Database connection failed",
    "Scheduled job started",
    "Unauthorized access attempt"
};

void print_log(const char *level) {
    time_t now = time(NULL);
    char timebuf[32];
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", localtime(&now));
    printf("%s %s %s\n", timebuf, level, messages[rand() % 8]);
    fflush(stdout);
}

int main(int argc, char *argv[]) {
    int interval = 1;
    const char *mode = "MIXED";

    if (argc > 1) interval = atoi(argv[1]);
    if (argc > 2) mode = argv[2];

    srand(time(NULL));

    while (1) {
        if (strcmp(mode, "INFO") == 0) {
            print_log("INFO");
        } else if (strcmp(mode, "WARNING") == 0) {
            print_log("WARNING");
        } else if (strcmp(mode, "ERROR") == 0) {
            print_log("ERROR");
        } else {
            const char *level = levels[rand() % 3];
            print_log(level);
        }
        sleep(interval);
    }

    return 0;
}
