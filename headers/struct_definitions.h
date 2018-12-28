  
  
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

  typedef enum{
    C_TYPE_IF,C_TYPE_ELSE,C_TYPE_WHILE,C_TYPE_FOR
  }c_type;

  typedef struct{
    c_type type;
    int val;
  }condition_block;

  typedef enum{
    COM_STATEMENT,COM_IF_TRUE,COM_IF_FALSE
  }com_state;

  typedef struct{
    char code[512];
    com_state state;
    int indent_level;
  }command;