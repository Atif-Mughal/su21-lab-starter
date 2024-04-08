#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (head == NULL) {
        return 0; // No cycle in an empty list
    }

    node *slow = head;
    node *fast = head;

    while (fast != NULL && fast->next != NULL) {
        slow = slow->next;          // Move slow pointer by one node
        fast = fast->next->next;    // Move fast pointer by two nodes

        if (slow == fast) {
            return 1;  // Cycle detected
        }
    }

    return 0; // No cycle found
}
