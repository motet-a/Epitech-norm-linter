/*
** board.h for allum1 in /home/grange_c/rendu/cpe/CPE_2015_Allum1/include/class/
**
** Made by Benjamin Grange
** Login   <grange_c@epitech.net>
**
** Started on  Thu Feb 11 17:46:57 2016 Benjamin Grange
** Last update Mon Feb 15 17:34:52 2016 Benjamin Grange
*/

#ifndef BOARD_H_
# define BOARD_H_

# include "my_plusplus.h"
# include "class.h"
# include "player.h"

/*
** Class: Board
** Parent class: None
** Derivated class: None
** Definition: board.c
** Methods: board_methods.c
*/
typedef struct		s_board
{
  t_class		base;
  t_modular		*modular;
  int			board_size;
  int			*board;
  t_player		*players;
  void			(*print_board)(struct s_board *);
  t_bool		(*generate_board)(struct s_board *);
  t_bool		(*play_turn)(struct s_board *);
  int			(*count_match)(struct s_board *);
  t_bool		(*can_remove_line)(struct s_board *, int);
  t_bool		(*can_remove_matches)(struct s_board *, int, int);
  t_bool		(*remove_match)(struct s_board *, int, int);
  t_bool		(*add_human_player)(struct s_board *);
  t_bool		(*add_ia_player)(struct s_board *, int);
}			t_board;

/*
** Object methods
*/
void	print_board(t_board *);
t_bool	remove_match(t_board *, int, int);
t_bool	generate_board(t_board *);
t_bool	play_turn(t_board *);
int	count_match(t_board *);
t_bool	add_human_player(struct s_board *);
t_bool	add_ia_player(struct s_board *, int);

/*
** Object description
*/
t_class		*board_description();

#endif /* !BOARD_H_ */
