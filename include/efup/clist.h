/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#pragma once

typedef struct clist {
   struct clist *next;
   struct clist *prev;
} clist_t;

# define CLIST_INIT(l) do {	\
   (l)->next = (l)->prev = (l);	\
} while (0)

# define CLIST_HEAD(l)  ((void *) (((clist_t *)(l))->next))
# define CLIST_TAIL(l)  (((clist_t *)(l))->prev)
# define CLIST_EMPTY(l) (((clist_t *)(l))->next == (l))
# define CLIST_END(l,n) (((clist_t *)(l)) == ((clist_t *)(n)))
# define CLIST_NEXT(n)  ((void *) (((clist_t *)(n))->next))
# define CLIST_PREV(n)  (((clist_t *)(n))->prev)

#define CLIST_ADDHEAD(l,n) do {		\
   clist_t *__n = (clist_t *) (n);	\
   clist_t *__t = (l)->next;		\
   						\
   __n->next = __t;				\
   __n->prev = (l);				\
   						\
   (l)->next = __n;				\
   __t->prev = __n;				\
} while (0)

# define CLIST_ADDTAIL(l,n) do {		\
   clist_t *__n = (clist_t *) (n);	\
   clist_t *__t = (l)->prev;		\
   						\
   __n->next = (l);				\
   __n->prev = __t;				\
   						\
   (l)->prev = __n;				\
   __t->next = __n;				\
} while (0)

# define CLIST_REMOVE(n) do {		\
   clist_t *__n = (clist_t *) (n);	\
   clist_t *__t = __n->prev;		\
   						\
   __n = __n->next;				\
   __t->next = __n;				\
   __n->prev = __t;				\
} while (0)

