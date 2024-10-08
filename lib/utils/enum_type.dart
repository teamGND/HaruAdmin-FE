enum LEVEL {
  ALPHABET,
  LEVEL1,
}

LEVEL levelFromString(String level) {
  switch (level) {
    case 'ALPHABET':
      return LEVEL.ALPHABET;
    case 'LEVEL1':
      return LEVEL.LEVEL1;
    default:
      return LEVEL.ALPHABET;
  }
}

enum CATEGORY { WORD, GRAMMAR, TEST, MIDTERM }

CATEGORY categoryFromString(String category) {
  switch (category) {
    case 'WORD':
      return CATEGORY.WORD;
    case 'GRAMMAR':
      return CATEGORY.GRAMMAR;
    case 'TEST':
      return CATEGORY.TEST;
    case 'MIDTERM':
      return CATEGORY.MIDTERM;
    default:
      return CATEGORY.WORD;
  }
}

enum CHAPTER_STATUS { APPROVE, DELETE, SHOWUSER, WAIT }

CHAPTER_STATUS chapterStatusFromString(String status) {
  switch (status) {
    case 'APPROVE':
      return CHAPTER_STATUS.APPROVE;
    case 'DELETE':
      return CHAPTER_STATUS.DELETE;
    case 'SHOWUSER':
      return CHAPTER_STATUS.SHOWUSER;
    case 'WAIT':
      return CHAPTER_STATUS.WAIT;
    default:
      return CHAPTER_STATUS.WAIT;
  }
}
