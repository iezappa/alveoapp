import 'daily_quote.dart';

/// The quote to show for [date] — deterministic per calendar day, so the same
/// day always shows the same line. Indexed by day of year and wrapped with a
/// modulo, so it keeps working while the list grows toward a full 366.
DailyQuote quoteForDay(DateTime date) {
  final dayOfYear = DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime(date.year)).inDays; // 0..365
  return dailyQuotes[dayOfYear % dailyQuotes.length];
}

/// Curated quotes from well-documented or public-domain sources only, so every
/// attribution can be trusted. Order is irrelevant (the day of year picks one).
/// Growing this toward 366 entries is pure content — no code change.
const List<DailyQuote> dailyQuotes = [
  DailyQuote(
    textEs:
        'Tienes poder sobre tu mente, no sobre los sucesos externos. Date '
        'cuenta de esto y encontrarás fuerza.',
    textEn:
        'You have power over your mind — not outside events. Realize this, '
        'and you will find strength.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'La felicidad de tu vida depende de la calidad de tus pensamientos.',
    textEn:
        'The happiness of your life depends upon the quality of your thoughts.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'El obstáculo en el camino se convierte en el camino. Dentro de cada '
        'dificultad hay una oportunidad.',
    textEn:
        'The impediment to action advances action. What stands in the way '
        'becomes the way.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'No desperdicies más tiempo discutiendo sobre lo que debe ser un buen '
        'hombre. Selo.',
    textEn:
        'Waste no more time arguing about what a good man should be. Be one.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'Elige no sentirte perjudicado y no te sentirás perjudicado.',
    textEn: "Choose not to be harmed — and you won't feel harmed.",
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Muy poco se necesita para una vida feliz; todo está dentro de ti, en '
        'tu forma de pensar.',
    textEn:
        'Very little is needed to make a happy life; it is all within '
        'yourself, in your way of thinking.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'Confina tu atención al presente.',
    textEn: 'Confine yourself to the present.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'El mejor modo de vengarte de tu enemigo es no parecerte a él.',
    textEn:
        'The best revenge is to be unlike him who performed the injury.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'La pérdida no es otra cosa que un cambio, y el cambio es el deleite '
        'de la naturaleza.',
    textEn:
        "Loss is nothing else but change, and change is Nature's delight.",
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Nada le sucede a nadie que no esté hecho por naturaleza para '
        'soportarlo.',
    textEn:
        'Nothing happens to anyone that he is not fitted by nature to bear.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'La mente que no se altera con las cosas externas es una fortaleza; no '
        'hay refugio más seguro.',
    textEn:
        'The mind free from passions is a citadel; a person has no more '
        'secure place of refuge.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Cuando te levantes por la mañana, piensa en el precioso privilegio de '
        'estar vivo: respirar, pensar, disfrutar, amar.',
    textEn:
        'When you arise in the morning, think of what a precious privilege it '
        'is to be alive — to breathe, to think, to enjoy, to love.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'No es que tengamos poco tiempo de vida, sino que perdemos mucho.',
    textEn:
        'It is not that we have a short time to live, but that we waste a lot '
        'of it.',
    author: 'Séneca',
    source: 'Sobre la brevedad de la vida',
  ),
  DailyQuote(
    textEs: 'Sufrimos más en la imaginación que en la realidad.',
    textEn: 'We suffer more often in imagination than in reality.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'Empieza de inmediato a vivir, y cuenta cada día como una vida entera.',
    textEn:
        'Begin at once to live, and count each separate day as a separate '
        'life.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs: 'A veces, incluso vivir es un acto de valentía.',
    textEn: 'Sometimes even to live is an act of courage.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'No hay viento favorable para quien no sabe a qué puerto se dirige.',
    textEn:
        'If a man knows not to which port he sails, no wind is favorable.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'Nada hay tan miserable como la mente de quien anticipa la desgracia.',
    textEn:
        'There is nothing so wretched as the mind of a man anticipating '
        'misfortune.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs: 'Todo el porvenir yace en la incertidumbre: vive ahora mismo.',
    textEn: 'The whole future lies in uncertainty: live immediately.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'Elige como guía a quien admires más por lo que hace que por lo que '
        'dice.',
    textEn:
        'Choose as a guide one whom you will admire more when you see him act '
        'than when you hear him speak.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'No estropees lo que tienes deseando lo que no tienes; lo que ahora '
        'tienes fue una vez algo que solo esperabas.',
    textEn:
        'Do not spoil what you have by desiring what you have not; what you '
        'now have was once among the things you only hoped for.',
    author: 'Epicuro',
  ),
  DailyQuote(
    textEs:
        'No son las cosas las que perturban a los hombres, sino las opiniones '
        'que se tienen de las cosas.',
    textEn:
        'Men are disturbed not by things, but by the views they take of '
        'things.',
    author: 'Epicteto',
    source: 'Enquiridión',
  ),
  DailyQuote(
    textEs:
        'No pidas que las cosas sucedan como quieres; desea que sucedan como '
        'suceden, y vivirás en paz.',
    textEn:
        'Do not seek to have events happen as you wish, but wish them to '
        'happen as they do, and you will go on well.',
    author: 'Epicteto',
    source: 'Enquiridión',
  ),
  DailyQuote(
    textEs: 'Primero dite qué quieres ser; luego haz lo que tengas que hacer.',
    textEn:
        'First say to yourself what you would be; and then do what you have to '
        'do.',
    author: 'Epicteto',
    source: 'Discursos',
  ),
  DailyQuote(
    textEs: 'Ninguna persona es libre si no es dueña de sí misma.',
    textEn: 'No man is free who is not master of himself.',
    author: 'Epicteto',
  ),
  DailyQuote(
    textEs:
        'La riqueza no consiste en tener grandes posesiones, sino en tener '
        'pocas necesidades.',
    textEn:
        'Wealth consists not in having great possessions, but in having few '
        'wants.',
    author: 'Epicteto',
  ),
  DailyQuote(
    textEs: 'Ninguna cosa grande se crea de repente.',
    textEn: 'No great thing is created suddenly.',
    author: 'Epicteto',
    source: 'Discursos',
  ),
  DailyQuote(
    textEs:
        'Si quieres mejorar, conténtate con que te crean necio y estúpido.',
    textEn:
        'If you want to improve, be content to be thought foolish and stupid.',
    author: 'Epicteto',
    source: 'Enquiridión',
  ),
  DailyQuote(
    textEs: 'Un viaje de mil millas comienza con un solo paso.',
    textEn: 'A journey of a thousand miles begins with a single step.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Quien conoce a los demás es sabio; quien se conoce a sí mismo está '
        'iluminado.',
    textEn:
        'Knowing others is wisdom; knowing yourself is enlightenment.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Quien vence a otros es fuerte; quien se vence a sí mismo es poderoso.',
    textEn:
        'He who conquers others is strong; he who conquers himself is mighty.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'La naturaleza no se apura, y sin embargo todo se cumple.',
    textEn: 'Nature does not hurry, yet everything is accomplished.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'Cuando dejo ir lo que soy, me convierto en lo que podría ser.',
    textEn: 'When I let go of what I am, I become what I might be.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Nada en el mundo es tan blando como el agua, y sin embargo nada la '
        'supera para desgastar lo duro.',
    textEn:
        'Nothing in the world is as soft and yielding as water, yet nothing '
        'is better at overcoming the hard and strong.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'El que sabe no habla; el que habla no sabe.',
    textEn: 'Those who know do not speak; those who speak do not know.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'Saber que no se sabe: eso es lo mejor.',
    textEn: 'To know that you do not know is the best.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Afronta lo difícil mientras aún es fácil; realiza la gran tarea con '
        'una serie de pequeños actos.',
    textEn:
        'Deal with the difficult while it is still easy; accomplish the great '
        'task by a series of small acts.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'El sabio no acumula: cuanto más da a los demás, más tiene.',
    textEn: 'The sage does not hoard: the more he does for others, the more he '
        'has.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'No importa lo despacio que vayas mientras no te detengas.',
    textEn:
        'It does not matter how slowly you go as long as you do not stop.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'El hombre que mueve montañas comienza apartando piedras pequeñas.',
    textEn:
        'The man who moves a mountain begins by carrying away small stones.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs:
        'Nuestra mayor gloria no está en no caer nunca, sino en levantarnos '
        'cada vez que caemos.',
    textEn:
        'Our greatest glory is not in never falling, but in rising every time '
        'we fall.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs:
        'Cuando veas a una buena persona, trata de imitarla; cuando veas a '
        'una que no lo es, examínate a ti mismo.',
    textEn:
        'When you see a good person, think of becoming like them. When you '
        'see someone not so good, reflect on your own weak points.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'Aprender sin pensar es esfuerzo perdido; pensar sin aprender es '
        'peligroso.',
    textEn:
        'Learning without thought is labour lost; thought without learning is '
        'perilous.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'La joya no puede pulirse sin fricción, ni la persona perfeccionarse '
        'sin pruebas.',
    textEn:
        'The gem cannot be polished without friction, nor a person perfected '
        'without trials.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs: 'La mente lo es todo. Nos convertimos en lo que pensamos.',
    textEn:
        'All that we are arises with our thoughts. With our thoughts we make '
        'the world.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs:
        'El odio nunca se apaga con odio; solo el amor lo apaga. Esta es la '
        'ley eterna.',
    textEn:
        'Hatred is never appeased by hatred; it is appeased by love alone. '
        'This is an eternal law.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs:
        'Es más noble conquistarse a uno mismo que vencer mil veces a mil '
        'hombres en batalla.',
    textEn:
        'Though one may conquer a thousand times a thousand men in battle, he '
        'who conquers himself is the noblest victor.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs: 'Vence a la ira con la calma; vence al mal con el bien.',
    textEn: 'Conquer anger with non-anger. Conquer evil with good.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs: 'La herida es el lugar por donde entra la luz.',
    textEn: 'The wound is the place where the Light enters you.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs:
        'Ayer era listo, por eso quería cambiar el mundo. Hoy soy sabio, por '
        'eso me estoy cambiando a mí mismo.',
    textEn:
        'Yesterday I was clever, so I wanted to change the world. Today I am '
        'wise, so I am changing myself.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'No te sientas solo: el universo entero está dentro de ti.',
    textEn: 'Do not feel lonely, the entire universe is inside you.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Lo que buscas te está buscando.',
    textEn: 'What you seek is seeking you.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Deja que la belleza de lo que amas sea lo que haces.',
    textEn: 'Let the beauty of what you love be what you do.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Tu dolor es la ruptura de la cáscara que encierra tu comprensión.',
    textEn:
        'Your pain is the breaking of the shell that encloses your '
        'understanding.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs: 'El trabajo es el amor hecho visible.',
    textEn: 'Work is love made visible.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'Cuando estés triste, mira otra vez en tu interior, y verás que '
        'lloras por aquello que fue tu deleite.',
    textEn:
        'When you are sorrowful look again in your heart, and you shall see '
        'that you are weeping for that which has been your delight.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'El amor no da nada sino de sí mismo y no toma nada sino de sí mismo.',
    textEn: 'Love gives naught but itself and takes naught but from itself.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'La generosidad es dar más de lo que puedes; el orgullo es tomar '
        'menos de lo que necesitas.',
    textEn:
        'Generosity is giving more than you can, and pride is taking less '
        'than you need.',
    author: 'Kahlil Gibran',
  ),
  DailyQuote(
    textEs:
        'Ve con confianza en la dirección de tus sueños. Vive la vida que has '
        'imaginado.',
    textEn:
        'Go confidently in the direction of your dreams. Live the life you '
        'have imagined.',
    author: 'Henry David Thoreau',
  ),
  DailyQuote(
    textEs:
        'No basta con estar ocupado; también lo están las hormigas. La '
        'pregunta es: ¿en qué estamos ocupados?',
    textEn:
        'It is not enough to be busy; so are the ants. The question is: what '
        'are we busy about?',
    author: 'Henry David Thoreau',
  ),
  DailyQuote(
    textEs: 'No puedes matar el tiempo sin herir a la eternidad.',
    textEn: 'You cannot kill time without injuring eternity.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs:
        'Una persona es rica en proporción a la cantidad de cosas que puede '
        'permitirse dejar en paz.',
    textEn:
        'A man is rich in proportion to the number of things which he can '
        'afford to let alone.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs: 'Solo amanece el día para el que está despierto.',
    textEn: 'Only that day dawns to which we are awake.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs:
        'Lo que hay detrás de nosotros y lo que hay delante son cuestiones '
        'minúsculas comparadas con lo que hay dentro de nosotros.',
    textEn:
        'What lies behind us and what lies before us are tiny matters '
        'compared to what lies within us.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs:
        'Escribe en tu corazón que cada día es el mejor día del año.',
    textEn:
        'Write it on your heart that every day is the best day in the year.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs: 'Adopta el ritmo de la naturaleza: su secreto es la paciencia.',
    textEn: "Adopt the pace of nature: her secret is patience.",
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs: 'Nada puede traerte paz sino tú mismo.',
    textEn: 'Nothing can bring you peace but yourself.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs: 'El único modo de tener un amigo es serlo.',
    textEn: 'The only way to have a friend is to be one.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs:
        'Mi vida ha estado llena de terribles desgracias, la mayoría de las '
        'cuales nunca sucedieron.',
    textEn:
        'My life has been full of terrible misfortunes, most of which never '
        'happened.',
    author: 'Michel de Montaigne',
  ),
  DailyQuote(
    textEs:
        'La cosa más grande del mundo es saber pertenecerse a uno mismo.',
    textEn:
        'The greatest thing in the world is to know how to belong to oneself.',
    author: 'Michel de Montaigne',
    source: 'Ensayos',
  ),
  DailyQuote(
    textEs: 'Caminante, no hay camino, se hace camino al andar.',
    textEn: 'Wanderer, there is no path, the path is made by walking.',
    author: 'Antonio Machado',
    source: 'Proverbios y cantares',
  ),
  DailyQuote(
    textEs: 'Hoy es siempre todavía.',
    textEn: 'Today is always still.',
    author: 'Antonio Machado',
  ),
  DailyQuote(
    textEs:
        'Despacito y buena letra: el hacer las cosas bien importa más que el '
        'hacerlas.',
    textEn:
        'Slowly and with a steady hand: doing things well matters more than '
        'doing them.',
    author: 'Antonio Machado',
  ),
  DailyQuote(
    textEs:
        'Es bueno saber que los vasos nos sirven para beber; lo malo es que '
        'no sabemos para qué sirve la sed.',
    textEn:
        'It is good to know that glasses serve us for drinking; the bad thing '
        'is that we do not know what thirst is for.',
    author: 'Antonio Machado',
    source: 'Proverbios y cantares',
  ),
  DailyQuote(
    textEs:
        'Cuando ya no somos capaces de cambiar una situación, nos enfrentamos '
        'al reto de cambiarnos a nosotros mismos.',
    textEn:
        'When we are no longer able to change a situation, we are challenged '
        'to change ourselves.',
    author: 'Viktor Frankl',
    source: 'El hombre en busca de sentido',
  ),
  DailyQuote(
    textEs:
        'Al hombre se le puede arrebatar todo salvo una cosa: la elección de '
        'su actitud ante cualquier circunstancia.',
    textEn:
        "Everything can be taken from a man but one thing: to choose one's "
        'attitude in any given set of circumstances.',
    author: 'Viktor Frankl',
    source: 'El hombre en busca de sentido',
  ),
  DailyQuote(
    textEs: 'Quien tiene un porqué para vivir puede soportar casi cualquier '
        'cómo.',
    textEn: 'He who has a why to live for can bear almost any how.',
    author: 'Friedrich Nietzsche',
    source: 'Crepúsculo de los ídolos',
  ),
  DailyQuote(
    textEs: 'Lo que no me mata me hace más fuerte.',
    textEn: 'What does not kill me makes me stronger.',
    author: 'Friedrich Nietzsche',
    source: 'Crepúsculo de los ídolos',
  ),
  DailyQuote(
    textEs:
        'Hay que tener aún un caos dentro de sí para poder dar a luz una '
        'estrella danzarina.',
    textEn:
        'One must still have chaos in oneself to be able to give birth to a '
        'dancing star.',
    author: 'Friedrich Nietzsche',
    source: 'Así habló Zaratustra',
  ),
  DailyQuote(
    textEs:
        'Madurez es haber recuperado la seriedad con la que se jugaba de '
        'niño.',
    textEn:
        'Maturity: to have rediscovered the seriousness one had as a child at '
        'play.',
    author: 'Friedrich Nietzsche',
    source: 'Más allá del bien y del mal',
  ),
  DailyQuote(
    textEs:
        'Ten paciencia con todo lo que está sin resolver en tu corazón y '
        'trata de amar las preguntas mismas.',
    textEn:
        'Be patient toward all that is unsolved in your heart and try to love '
        'the questions themselves.',
    author: 'Rainer Maria Rilke',
    source: 'Cartas a un joven poeta',
  ),
  DailyQuote(
    textEs:
        'Quizá todos los dragones de nuestra vida son princesas que esperan '
        'vernos actuar, aunque sea una vez, con belleza y valentía.',
    textEn:
        'Perhaps all the dragons in our lives are princesses who are only '
        'waiting to see us act, just once, with beauty and courage.',
    author: 'Rainer Maria Rilke',
    source: 'Cartas a un joven poeta',
  ),
  DailyQuote(
    textEs:
        'Deja que todo te suceda: la belleza y el terror. Sigue adelante. '
        'Ningún sentimiento es definitivo.',
    textEn:
        'Let everything happen to you: beauty and terror. Just keep going. No '
        'feeling is final.',
    author: 'Rainer Maria Rilke',
  ),
  DailyQuote(
    textEs:
        'La vida solo puede comprenderse mirando hacia atrás, pero ha de '
        'vivirse mirando hacia adelante.',
    textEn:
        'Life can only be understood backwards; but it must be lived '
        'forwards.',
    author: 'Søren Kierkegaard',
  ),
  DailyQuote(
    textEs:
        'Atreverse es perder el equilibrio un instante. No atreverse es '
        'perderse a uno mismo.',
    textEn:
        "To dare is to lose one's footing momentarily. Not to dare is to "
        'lose oneself.',
    author: 'Søren Kierkegaard',
  ),
  DailyQuote(
    textEs:
        'Dentro de ti hay una quietud y un refugio al que puedes retirarte en '
        'cualquier momento y ser tú mismo.',
    textEn:
        'Within you there is a stillness and a sanctuary to which you can '
        'retreat at any time and be yourself.',
    author: 'Hermann Hesse',
    source: 'Siddhartha',
  ),
  DailyQuote(
    textEs:
        'La curiosa paradoja es que cuando me acepto tal como soy, entonces '
        'puedo cambiar.',
    textEn:
        'The curious paradox is that when I accept myself just as I am, then '
        'I can change.',
    author: 'Carl Rogers',
    source: 'El proceso de convertirse en persona',
  ),
  DailyQuote(
    textEs:
        'Y llegó el día en que el riesgo de permanecer apretada en un capullo '
        'fue más doloroso que el riesgo de florecer.',
    textEn:
        'And the day came when the risk to remain tight in a bud was more '
        'painful than the risk it took to blossom.',
    author: 'Anaïs Nin',
  ),
  DailyQuote(
    textEs: 'Actúa como si lo que haces marcara la diferencia. La marca.',
    textEn: 'Act as if what you do makes a difference. It does.',
    author: 'William James',
  ),
  DailyQuote(
    textEs: 'Domina tu mente, o ella te dominará a ti.',
    textEn: 'Rule your mind, or it will rule you.',
    author: 'Horacio',
    source: 'Epístolas',
  ),
  DailyQuote(
    textEs: 'Cae siete veces, levántate ocho.',
    textEn: 'Fall seven times, stand up eight.',
    author: 'Proverbio japonés',
  ),
  DailyQuote(
    textEs:
        'El mejor momento para plantar un árbol era hace veinte años. El '
        'segundo mejor momento es ahora.',
    textEn:
        'The best time to plant a tree was twenty years ago. The second best '
        'time is now.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Si quieres ir rápido, ve solo. Si quieres llegar lejos, ve '
        'acompañado.',
    textEn:
        'If you want to go fast, go alone. If you want to go far, go '
        'together.',
    author: 'Proverbio africano',
  ),
  DailyQuote(
    textEs: 'Poco a poco se anda lejos.',
    textEn: 'Little by little, one walks far.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'No hay mal que por bien no venga.',
    textEn: 'There is no bad from which some good does not come.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Cuando soplan vientos de cambio, algunos construyen muros y otros '
        'molinos.',
    textEn:
        'When the winds of change blow, some build walls and others build '
        'windmills.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'Sé como el bambú: dóblate con el viento, pero no te quiebres.',
    textEn: 'Be like bamboo: bend with the wind, but do not break.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'La mañana es más sabia que la tarde.',
    textEn: 'The morning is wiser than the evening.',
    author: 'Proverbio ruso',
  ),
  DailyQuote(
    textEs:
        'Piensa en ti mismo como si ya hubieras muerto. Has vivido tu vida. '
        'Ahora toma lo que queda y vívelo bien.',
    textEn:
        "Think of yourself as dead. You have lived your life. Now take what's "
        'left and live it properly.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Vive cada día como si fuera el último: sin frenesí, sin apatía, sin '
        'fingir.',
    textEn:
        'Live each day as if it were your last: without frenzy, without '
        'apathy, without pretence.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'Nuestra vida es lo que nuestros pensamientos hacen de ella.',
    textEn: 'Our life is what our thoughts make it.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Adáptate a lo que te ha tocado en suerte, y ama a las personas con '
        'las que el destino te ha unido, pero hazlo de todo corazón.',
    textEn:
        'Accept the things to which fate binds you, and love the people with '
        'whom fate brings you together — but do so with all your heart.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Todo lo que oímos es una opinión, no un hecho. Todo lo que vemos es '
        'una perspectiva, no la verdad.',
    textEn:
        'Everything we hear is an opinion, not a fact. Everything we see is a '
        'perspective, not the truth.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs: 'El alma se tiñe del color de sus pensamientos.',
    textEn: 'The soul becomes dyed with the color of its thoughts.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'No actúes como si fueras a vivir diez mil años. Mientras vivas, '
        'mientras puedas, sé bueno.',
    textEn:
        'Do not act as if you had ten thousand years to live. While you live, '
        'while it is in your power, be good.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Cuando te cueste levantarte por la mañana, recuerda que te levantas '
        'para hacer el trabajo de un ser humano.',
    textEn:
        'At dawn, when you have trouble getting out of bed, tell yourself: I '
        'am rising to do the work of a human being.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Nada tiene tanto poder para ampliar la mente como investigar de forma '
        'sistemática y veraz todo lo que se te presenta en la vida.',
    textEn:
        'Nothing has such power to broaden the mind as the ability to '
        'investigate systematically and truly all that comes under your '
        'observation in life.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'Nada, en mi opinión, indica mejor una mente bien ordenada que la '
        'capacidad de detenerse y pasar tiempo consigo mismo.',
    textEn:
        "Nothing is a surer sign of a well-ordered mind than a man's ability "
        'to stop and spend time with himself.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'Piensa mucho tiempo si debes admitir a alguien en tu amistad; pero '
        'cuando te hayas decidido, acógelo de todo corazón.',
    textEn:
        'Ponder for a long time whether you shall admit a given person to '
        'your friendship; but when you have decided, welcome him with all '
        'your heart.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs: 'El tiempo descubre la verdad.',
    textEn: 'Time discovers the truth.',
    author: 'Séneca',
    source: 'Sobre la ira',
  ),
  DailyQuote(
    textEs:
        'Nadie es más desdichado que quien nunca afronta la adversidad, pues '
        'no se le permite ponerse a prueba.',
    textEn:
        'No man is more unhappy than he who never faces adversity, for he is '
        'not permitted to prove himself.',
    author: 'Séneca',
    source: 'Sobre la providencia',
  ),
  DailyQuote(
    textEs: 'No expliques tu filosofía. Encárnala.',
    textEn: "Don't explain your philosophy. Embody it.",
    author: 'Epicteto',
  ),
  DailyQuote(
    textEs:
        'Toda dificultad tiene dos asas: una por la que puede llevarse, y '
        'otra por la que no.',
    textEn:
        'Every difficulty has two handles: one by which it can be carried, '
        'and one by which it cannot.',
    author: 'Epicteto',
    source: 'Enquiridión',
  ),
  DailyQuote(
    textEs:
        'Ante cada cosa que te suceda, vuélvete hacia ti mismo y pregúntate '
        'qué recurso tienes para afrontarla.',
    textEn:
        'On the occasion of everything that befalls you, turn to yourself and '
        'ask what power you have to make use of it.',
    author: 'Epicteto',
    source: 'Enquiridión',
  ),
  DailyQuote(
    textEs: 'Solo las personas educadas son libres.',
    textEn: 'Only the educated are free.',
    author: 'Epicteto',
    source: 'Discursos',
  ),
  DailyQuote(
    textEs: 'A quien se contenta con lo que tiene, nada le falta.',
    textEn: 'He who is contented with what he has is rich.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'El que sabe cuándo detenerse está libre de peligro.',
    textEn: 'He who knows when to stop is free from danger.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'Cede y prevalecerás; inclínate y te enderezarás.',
    textEn: 'Yield and overcome; bend and be straight.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'Un árbol que llena los brazos de un hombre nació de una diminuta '
        'semilla.',
    textEn: "A tree as big as a man's embrace grows from a tiny sprout.",
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Porque el sabio nunca se esfuerza por ser grande, alcanza la '
        'grandeza.',
    textEn:
        'Because the sage never strives for greatness, he achieves greatness.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'No te preocupes por que no te conozcan; preocúpate por no conocer a '
        'los demás.',
    textEn:
        'Do not be concerned that others do not know you; be concerned that '
        'you do not know others.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'Exígete mucho a ti mismo y espera poco de los demás: así te '
        'ahorrarás disgustos.',
    textEn:
        'Demand much from yourself and expect little from others, and you '
        'will spare yourself resentment.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'La persona superior es modesta al hablar, pero se excede en sus '
        'actos.',
    textEn:
        'The superior person is modest in speech but exceeds in action.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs:
        'Como una roca no se mueve con el viento, el sabio permanece firme '
        'ante el elogio y la censura.',
    textEn:
        'As a solid rock is not shaken by the wind, the wise are not moved by '
        'praise or blame.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs:
        'No menosprecies lo pequeño del bien pensando que no te alcanzará: '
        'gota a gota se llena el cántaro.',
    textEn:
        "Do not think lightly of good, saying 'It will not come to me.' Drop "
        'by drop the water pot is filled.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs: 'Quien vive atento no muere; los descuidados ya son como muertos.',
    textEn:
        'Heedfulness is the path to the deathless; heedlessness is the path '
        'to death.',
    author: 'Buda',
    source: 'Dhammapada',
  ),
  DailyQuote(
    textEs: 'La brisa del alba tiene secretos que contarte. No vuelvas a '
        'dormirte.',
    textEn:
        "The breeze at dawn has secrets to tell you. Don't go back to sleep.",
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Vende tu astucia y compra desconcierto.',
    textEn: 'Sell your cleverness and buy bewilderment.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Deja de actuar tan pequeño. Eres el universo en éxtasis.',
    textEn: 'Stop acting so small. You are the universe in ecstatic motion.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs: 'Donde hay ruina, hay esperanza de un tesoro.',
    textEn: 'Where there is ruin, there is hope for a treasure.',
    author: 'Rumi',
  ),
  DailyQuote(
    textEs:
        'El amor no posee ni quiere ser poseído, porque al amor le basta el '
        'amor.',
    textEn:
        'Love possesses not, nor would it be possessed; for love is '
        'sufficient unto love.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'Tu razón y tu pasión son el timón y las velas de tu alma navegante.',
    textEn:
        'Your reason and your passion are the rudder and the sails of your '
        'seafaring soul.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'Si no podéis trabajar con amor, sino solo con desagrado, mejor sería '
        'que dejarais el trabajo.',
    textEn:
        'If you cannot work with love but only with distaste, it is better '
        'that you should leave your work.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs:
        'A tus hijos puedes darles tu amor, pero no tus pensamientos, porque '
        'ellos tienen los suyos.',
    textEn:
        'You may give your children your love but not your thoughts, for they '
        'have their own thoughts.',
    author: 'Kahlil Gibran',
    source: 'El Profeta',
  ),
  DailyQuote(
    textEs: 'Nuestra vida se desperdicia en detalles. Simplifica, simplifica.',
    textEn:
        'Our life is frittered away by detail. Simplify, simplify.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs:
        'El precio de cualquier cosa es la cantidad de vida que intercambias '
        'por ella.',
    textEn:
        'The price of anything is the amount of life you exchange for it.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs:
        'Si has construido castillos en el aire, tu trabajo no se pierde: '
        'ahora pon los cimientos debajo.',
    textEn:
        'If you have built castles in the air, your work need not be lost; '
        'now put the foundations under them.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs: 'No importa lo que miras, sino lo que ves.',
    textEn: "It's not what you look at that matters, it's what you see.",
    author: 'Henry David Thoreau',
  ),
  DailyQuote(
    textEs: 'Confía en ti: cada corazón vibra con esa cuerda de hierro.',
    textEn: 'Trust thyself: every heart vibrates to that iron string.',
    author: 'Ralph Waldo Emerson',
    source: 'Confianza en uno mismo',
  ),
  DailyQuote(
    textEs: 'Haz aquello que temes, y la muerte del miedo es segura.',
    textEn: 'Do the thing you fear, and the death of fear is certain.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs: 'El único regalo verdadero es una parte de ti mismo.',
    textEn: 'The only gift is a portion of thyself.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs: 'Lo que eres habla tan fuerte que no me deja oír lo que dices.',
    textEn:
        'What you are speaks so loudly I cannot hear what you say.',
    author: 'Ralph Waldo Emerson',
  ),
  DailyQuote(
    textEs:
        'El valor de la vida no está en la cantidad de días, sino en el uso '
        'que hacemos de ellos.',
    textEn:
        'The value of life lies not in the length of days, but in the use we '
        'make of them.',
    author: 'Michel de Montaigne',
    source: 'Ensayos',
  ),
  DailyQuote(
    textEs: 'Mi oficio y mi arte es vivir.',
    textEn: 'My trade and my art is to live.',
    author: 'Michel de Montaigne',
    source: 'Ensayos',
  ),
  DailyQuote(
    textEs:
        'Todo pasa y todo queda, pero lo nuestro es pasar, hacer caminos, '
        'caminos sobre la mar.',
    textEn:
        'Everything passes and everything stays, but our fate is to pass, to '
        'make paths, paths over the sea.',
    author: 'Antonio Machado',
    source: 'Proverbios y cantares',
  ),
  DailyQuote(
    textEs:
        'Se miente más de la cuenta por falta de fantasía: también la verdad '
        'se inventa.',
    textEn:
        'We lie more than we need to for lack of imagination: the truth too '
        'is invented.',
    author: 'Antonio Machado',
    source: 'Proverbios y cantares',
  ),
  DailyQuote(
    textEs: 'No hay hechos, solo interpretaciones.',
    textEn: 'There are no facts, only interpretations.',
    author: 'Friedrich Nietzsche',
  ),
  DailyQuote(
    textEs:
        'Lo que se hace por amor sucede siempre más allá del bien y del mal.',
    textEn:
        'What is done out of love always takes place beyond good and evil.',
    author: 'Friedrich Nietzsche',
    source: 'Más allá del bien y del mal',
  ),
  DailyQuote(
    textEs:
        'Quien quiera aprender a volar primero debe aprender a estar de pie, '
        'a caminar, a correr y a bailar: no se aprende a volar volando.',
    textEn:
        'He who would learn to fly must first learn to stand and walk and run '
        'and dance; one cannot fly into flying.',
    author: 'Friedrich Nietzsche',
    source: 'Así habló Zaratustra',
  ),
  DailyQuote(
    textEs:
        'El futuro entra en nosotros mucho antes de que suceda.',
    textEn: 'The future enters into us long before it happens.',
    author: 'Rainer Maria Rilke',
    source: 'Cartas a un joven poeta',
  ),
  DailyQuote(
    textEs:
        'Solo hay un camino: entrar en uno mismo. Nadie puede aconsejarte ni '
        'ayudarte, nadie.',
    textEn:
        'There is only one way: go within. Nobody can counsel or help you, '
        'nobody.',
    author: 'Rainer Maria Rilke',
    source: 'Cartas a un joven poeta',
  ),
  DailyQuote(
    textEs:
        'Vive ahora las preguntas. Quizá un día lejano, sin darte cuenta, '
        'vivas la respuesta.',
    textEn:
        'Live the questions now. Perhaps you will then gradually, without '
        'noticing it, live along some day into the answer.',
    author: 'Rainer Maria Rilke',
    source: 'Cartas a un joven poeta',
  ),
  DailyQuote(
    textEs: 'La ansiedad es el vértigo de la libertad.',
    textEn: 'Anxiety is the dizziness of freedom.',
    author: 'Søren Kierkegaard',
    source: 'El concepto de la angustia',
  ),
  DailyQuote(
    textEs:
        'La función de la oración no es influir en Dios, sino cambiar la '
        'naturaleza de quien ora.',
    textEn:
        'The function of prayer is not to influence God, but to change the '
        'nature of the one who prays.',
    author: 'Søren Kierkegaard',
  ),
  DailyQuote(
    textEs:
        'Todos los problemas de la humanidad vienen de la incapacidad del '
        'hombre de quedarse quieto y solo en una habitación.',
    textEn:
        "All of humanity's problems stem from man's inability to sit quietly "
        'in a room alone.',
    author: 'Blaise Pascal',
    source: 'Pensamientos',
  ),
  DailyQuote(
    textEs: 'El corazón tiene razones que la razón no entiende.',
    textEn: 'The heart has its reasons of which reason knows nothing.',
    author: 'Blaise Pascal',
    source: 'Pensamientos',
  ),
  DailyQuote(
    textEs:
        'El hombre es una caña, la más débil de la naturaleza, pero una caña '
        'que piensa.',
    textEn:
        'Man is but a reed, the weakest in nature, but he is a thinking reed.',
    author: 'Blaise Pascal',
    source: 'Pensamientos',
  ),
  DailyQuote(
    textEs:
        'Trata a las personas como si fueran lo que deberían ser y las '
        'ayudarás a llegar a serlo.',
    textEn:
        'Treat people as if they were what they ought to be, and you help '
        'them become what they are capable of being.',
    author: 'Johann Wolfgang von Goethe',
  ),
  DailyQuote(
    textEs: 'El talento se cultiva en la calma; el carácter, en la tempestad.',
    textEn:
        'Talent is nurtured in solitude; character is formed in the storms '
        'of life.',
    author: 'Johann Wolfgang von Goethe',
  ),
  DailyQuote(
    textEs: 'Quien no avanza cada día, retrocede cada día.',
    textEn: 'He who moves not forward, goes backward.',
    author: 'Johann Wolfgang von Goethe',
  ),
  DailyQuote(
    textEs:
        'Todos piensan en cambiar el mundo, pero nadie piensa en cambiarse a '
        'sí mismo.',
    textEn:
        'Everyone thinks of changing the world, but no one thinks of changing '
        'himself.',
    author: 'León Tolstói',
  ),
  DailyQuote(
    textEs: 'La verdadera vida se vive cuando ocurren pequeños cambios.',
    textEn: 'True life is lived when tiny changes occur.',
    author: 'León Tolstói',
  ),
  DailyQuote(
    textEs:
        'El sufrimiento deja de ser sufrimiento en cuanto encuentra un '
        'sentido.',
    textEn:
        'Suffering ceases to be suffering at the moment it finds a meaning.',
    author: 'Viktor Frankl',
    source: 'El hombre en busca de sentido',
  ),
  DailyQuote(
    textEs:
        'No se trata de qué esperamos de la vida, sino de qué espera la vida '
        'de nosotros.',
    textEn:
        'It did not really matter what we expected from life, but rather what '
        'life expected from us.',
    author: 'Viktor Frankl',
    source: 'El hombre en busca de sentido',
  ),
  DailyQuote(
    textEs:
        'La buena vida es un proceso, no un estado; una dirección, no un '
        'destino.',
    textEn:
        'The good life is a process, not a state of being. It is a '
        'direction, not a destination.',
    author: 'Carl Rogers',
    source: 'El proceso de convertirse en persona',
  ),
  DailyQuote(
    textEs:
        'Un cuarto sin libros es como un cuerpo sin alma.',
    textEn: 'A room without books is like a body without a soul.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs:
        'Cualquiera puede equivocarse; solo el necio persiste en su error.',
    textEn:
        'Any man can make a mistake; only a fool keeps making the same one.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs:
        'La gratitud no solo es la mayor de las virtudes, sino la madre de '
        'todas las demás.',
    textEn:
        'Gratitude is not only the greatest of virtues, but the parent of '
        'all the others.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs:
        'Nadie se baña dos veces en el mismo río, porque ni el río ni la '
        'persona son ya los mismos.',
    textEn:
        'No man ever steps in the same river twice, for it is not the same '
        'river and he is not the same man.',
    author: 'Heráclito',
  ),
  DailyQuote(
    textEs: 'El carácter de una persona es su destino.',
    textEn: "Character is destiny.",
    author: 'Heráclito',
  ),
  DailyQuote(
    textEs: 'El sol es nuevo cada día.',
    textEn: 'The sun is new each day.',
    author: 'Heráclito',
  ),
  DailyQuote(
    textEs: 'La mente no es un recipiente para llenar, sino un fuego para '
        'encender.',
    textEn:
        'The mind is not a vessel to be filled, but a fire to be kindled.',
    author: 'Plutarco',
  ),
  DailyQuote(
    textEs:
        'Nada es miserable si no lo crees así; y toda suerte es dichosa para '
        'quien la lleva con serenidad.',
    textEn:
        'Nothing is miserable unless you think it so; and every lot is happy '
        'if borne with equanimity.',
    author: 'Boecio',
    source: 'La consolación de la filosofía',
  ),
  DailyQuote(
    textEs:
        'Rara vez somos tan desdichados ni tan felices como imaginamos.',
    textEn:
        'We are never so happy nor so unhappy as we imagine.',
    author: 'François de La Rochefoucauld',
    source: 'Máximas',
  ),
  DailyQuote(
    textEs:
        'La mayor revolución de nuestra generación es descubrir que, al '
        'cambiar las actitudes de la mente, se puede cambiar la vida.',
    textEn:
        'The greatest discovery of my generation is that human beings can '
        'alter their lives by altering their attitudes of mind.',
    author: 'William James',
  ),
  DailyQuote(
    textEs:
        'La reputación es lo que otros creen de ti; el carácter, lo que en '
        'verdad eres.',
    textEn:
        'Reputation is what others believe you to be; character is what you '
        'truly are.',
    author: 'Thomas Paine',
  ),
  DailyQuote(
    textEs:
        'Un barco está seguro en el puerto, pero no es para eso que se '
        'construyen los barcos.',
    textEn:
        'A ship in harbor is safe, but that is not what ships are built for.',
    author: 'John A. Shedd',
  ),
  DailyQuote(
    textEs: 'Cuando bebas agua, acuérdate de la fuente.',
    textEn: 'When you drink water, remember the spring.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'Cava el pozo antes de tener sed.',
    textEn: 'Dig the well before you are thirsty.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'Es mejor encender una vela que maldecir la oscuridad.',
    textEn: 'It is better to light a candle than to curse the darkness.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'Cuando el alumno está listo, aparece el maestro.',
    textEn: 'When the student is ready, the teacher appears.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Quien tiene salud tiene esperanza, y quien tiene esperanza lo tiene '
        'todo.',
    textEn:
        'He who has health has hope, and he who has hope has everything.',
    author: 'Proverbio árabe',
  ),
  DailyQuote(
    textEs: 'La paciencia es amarga, pero su fruto es dulce.',
    textEn: 'Patience is bitter, but its fruit is sweet.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Habla poco y bien, y te tendrán por alguien.',
    textEn: 'Speak little and well, and you will be thought someone.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La felicidad es un cómo, no un qué; un talento, no un objeto.',
    textEn: 'Happiness is a how, not a what; a talent, not an object.',
    author: 'Hermann Hesse',
  ),
  DailyQuote(
    textEs:
        'Cae siete veces y levántate ocho; la fuerza está en levantarse cada '
        'vez.',
    textEn:
        'Fall down seven times, get up eight; the strength is in rising each '
        'time.',
    author: 'Proverbio japonés',
  ),
];
