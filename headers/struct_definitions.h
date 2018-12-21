  
  
  typedef union id_val{
    int i;
    float f;
    double d;
    char c;
  }id_val;

  typedef enum id_type
  {
    TYPE_INT,TYPE_FLOAT,TYPE_DOUBLE,TYPE_CHAR
  }id_type;

  typedef struct Identifier
  {
    enum id_type type;
    char name[30];
   union id_val x;

  }identifier;