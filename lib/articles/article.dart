class Article {
  final String title;
  final String url;

  Article({required this.title, required this.url});
}

List<Article> articles = [
  Article(
    title: 'Article 1',
    url: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10479530/',
  ),
  Article(
    title: 'Article 2',
    url: 'https://www.medicalnewstoday.com/articles/319366',
  ),
];
