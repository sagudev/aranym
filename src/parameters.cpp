/* MJ 2001 */
#include "sysdeps.h"

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

#include "parameters.h"

#define ARANYMRC	"/.aranymrc"

static struct option const long_options[] =
{
  {"ttram", required_argument, 0, 'T'},
  {"rom", required_argument, 0, 'R'},
  {"resolution", required_argument, 0, 'r'},
  {"debug", no_argument, 0, 'd'},
  {"fullscreen", no_argument, 0, 'f'},
  {"help", no_argument, 0, 'h'},
  {"version", no_argument, 0, 'V'},
  {NULL, 0, NULL, 0}
};

char *program_name;
char *rom_path;

uint8 start_debug = 0;			// Start debugger
uint8 fullscreen = 0;			// Boot in Fullscreen
uint16 boot_color_depth = 1;		// Boot in color depth
extern uint32 TTRAMSize;		// TTRAM size

static void decode_ini_file(void);

void usage (int status) {
  printf ("ARAnyM\n");
  printf ("Usage: %s [OPTION]... [FILE]...\n", program_name);
  printf ("\
Options:
  -R, --rom NAME             ROM file NAME\n\
  -T, --ttram SIZE           TT-RAM size\n\
  -d, --debug                start debugger\n\
  -f, --fullscreen           start in fullscreen\n\
  -r, --resolution <X>       boot in X color depth [1,2,4,8,16]\n\
  -h, --help                 display this help and exit\n\
  -V, --version              output version information and exit\n\
");
  exit (status);
}

int decode_switches (int argc, char **argv) {
  int c;

  decode_ini_file();
  
  while ((c = getopt_long (argc, argv,
                           "R:" /* ROM file */
                           "d"  /* debugger */
			   "T:" /* TT-RAM */
                           "f"  /* fullscreen */
                           "r:"  /* resolution */
			   "h"	/* help */
			   "V"	/* version */,
			   long_options, (int *) 0)) != EOF) {
    switch (c) {
      case 'V':
        printf ("%s\n", VERSION_STRING);
        exit (0);

      case 'h':
        usage (0);
	
      case 'd':
        start_debug = 1;
        break;
	
      case 'f':
        fullscreen = 1;
        break;
	
      case 'R':
        rom_path = strdup(optarg);
        break;

      case 'r':
        boot_color_depth = atoi(optarg);
        break;

      case 'T':
        TTRAMSize = atoi(optarg);
        break;

      default:
        usage (EXIT_FAILURE);
    }
  }
  return optind;
}

static void decode_ini_file(void) {
  FILE *f;
  char c;
  char *s;
  char *rcfile;
  char *home;
  if ((home = getenv("HOME")) != NULL) {
    if ((rcfile = (char *)malloc((strlen(home) + strlen(ARANYMRC) + 1) * sizeof(char))) == NULL) {
      fprintf(stderr, "Not enough memory\n");
      exit(-1);
    }
    strcpy(rcfile, home);
    strcat(rcfile, ARANYMRC);
    if ((f = fopen(rcfile, "r")) != 0) {
      fprintf(stderr, ARANYMRC" found\n");
      for (;;) {
        switch(getc(f)) {
          case 'd':
            start_debug = 1;
            while ((c = getc(f)) != '\n' && (c != EOF))
              ;
            break;

          case 'R':
            (void) getc(f);
            if ((rom_path = (char *)malloc(sizeof(char))) == NULL) {
	      fprintf(stderr, "Not enough memory\n");
	      exit(-1);
	    }

            while ((c = getc(f)) != '\n' && (c != EOF)) {
              s = rom_path;
	      if ((rom_path = (char *)malloc((strlen(s)+2) * sizeof(char))) == NULL) {
	        fprintf(stderr, "Not enough memory\n");
		exit(-1);
	      }
	      strcpy(rom_path, s);
	      rom_path[strlen(s)] = c;
	      rom_path[strlen(s)+1] = '\0';
	      free((void *)s);
	    }
            break;

          case EOF:
	    fclose(f);
	    return;

          default:
            fprintf(stderr, "Unknown in ~/.aranym: ");
            while ((c = getc(f)) != '\n' && (c != EOF))
              fprintf(stderr, "%c", c);
	    fprintf(stderr, "\n");
            exit(-1);
        }
      }
    }
  }
}
