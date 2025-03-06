Map<int, dynamic> parentCategories = {
  0: {"eng": "Old Testament", "spa": "El Antiguo Testamento"},
  1: {"eng": "New Testament", "spa": "El Nuevo Testamento"},
};

Map<int, dynamic> categories = {
  0: {
    "parent_category": 0,
    "eng": "Books of the Law/The Pentateuch",
    "spa": "Pentateuco",
  },
  1: {
    "parent_category": 0,
    "eng": "Historical Books",
    "spa": "Libros Historicos",
  },
  2: {
    "parent_category": 0,
    "eng": "Poetic Books/Books of Wisdom",
    "spa": "Libros Sapienciales",
  },
  3: {
    "parent_category": 0,
    "eng": "Major Prophetic Books",
    "spa": "Profetas Mayores",
  },
  4: {
    "parent_category": 0,
    "eng": "Minor Prophetic Books",
    "spa": "Profetas Menores",
  },
  5: {"parent_category": 1, "eng": "The Gospels", "spa": "Evangelios"},
  6: {
    "parent_category": 1,
    "eng": "The Acts of the Apostles",
    "spa": "Historia Apostolica/Narrativa",
  },
  7: {
    "parent_category": 1,
    "eng": "Paul's Letters (Epistles)",
    "spa": "Cartas (Epístolas) Paulinas",
  },
  8: {
    "parent_category": 1,
    "eng": "General Letters (Epistles)",
    "spa": "Cartas (Epístolas) Generales",
  },
  9: {
    "parent_category": 1,
    "eng": "The Book of Revelations/Apocalypse",
    "spa": "Profecía/Apocalipsis",
  },
};

Map<String, dynamic> bookCategoryMap = {
  "GEN": 0,
  "EXO": 0,
  "LEV": 0,
  "NUM": 0,
  "DEU": 0,
  "JOS": 1,
  "JDG": 1,
  "RUT": 1,
  "1SA": 1,
  "2SA": 1,
  "1KI": 1,
  "2KI": 1,
  "1CH": 1,
  "2CH": 1,
  "EZR": 1,
  "NEH": 1,
  "EST": 1,
  "JOB": 2,
  "PSA": 2,
  "PRO": 2,
  "ECC": 2,
  "SNG": 2,
  "ISA": 3,
  "JER": 3,
  "LAM": 3,
  "EZK": 3,
  "DAN": 3,
  "HOS": 4,
  "JOL": 4,
  "AMO": 4,
  "OBA": 4,
  "JON": 4,
  "MIC": 4,
  "NAM": 4,
  "HAB": 4,
  "ZEP": 4,
  "HAG": 4,
  "ZEC": 4,
  "MAL": 4,
  "MAT": 5,
  "MRK": 5,
  "LUK": 5,
  "JHN": 5,
  "ACT": 6,
  "ROM": 7,
  "1CO": 7,
  "2CO": 7,
  "GAL": 7,
  "EPH": 7,
  "PHP": 7,
  "COL": 7,
  "1TH": 7,
  "2TH": 7,
  "1TI": 7,
  "2TI": 7,
  "TIT": 7,
  "PHM": 7,
  "HEB": 8,
  "JAS": 8,
  "1PE": 8,
  "2PE": 8,
  "1JN": 8,
  "2JN": 8,
  "3JN": 8,
  "JUD": 8,
  "REV": 9,
};

dynamic getCategoryForBook(String bookId) {
  int bookCategoryId = bookCategoryMap[bookId];
  dynamic category = categories[bookCategoryId];

  return category;
}

dynamic getParentCategoryForBook(String bookId) {
  dynamic category = getCategoryForBook(bookId);

  int parentCategoryId = category['parent_category'];
  dynamic parentCategory = parentCategories[parentCategoryId];

  return parentCategory;
}
