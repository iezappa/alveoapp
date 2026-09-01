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
    textEs:
        'La felicidad de tu vida depende de la calidad de tus pensamientos.',
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
    textEn: 'The best revenge is to be unlike him who performed the injury.',
    author: 'Marco Aurelio',
    source: 'Meditaciones',
  ),
  DailyQuote(
    textEs:
        'La pérdida no es otra cosa que un cambio, y el cambio es el deleite '
        'de la naturaleza.',
    textEn: "Loss is nothing else but change, and change is Nature's delight.",
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
    textEs: 'No es que tengamos poco tiempo de vida, sino que perdemos mucho.',
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
    textEn: 'If a man knows not to which port he sails, no wind is favorable.',
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
    textEs: 'Si quieres mejorar, conténtate con que te crean necio y estúpido.',
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
    textEn: 'Knowing others is wisdom; knowing yourself is enlightenment.',
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
    textEn:
        'The sage does not hoard: the more he does for others, the more he '
        'has.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs: 'No importa lo despacio que vayas mientras no te detengas.',
    textEn: 'It does not matter how slowly you go as long as you do not stop.',
    author: 'Confucio',
    source: 'Analectas',
  ),
  DailyQuote(
    textEs: 'El hombre que mueve montañas comienza apartando piedras pequeñas.',
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
    textEs: 'Escribe en tu corazón que cada día es el mejor día del año.',
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
    textEs: 'La cosa más grande del mundo es saber pertenecerse a uno mismo.',
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
    textEs:
        'Quien tiene un porqué para vivir puede soportar casi cualquier '
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
    textEs:
        'Un árbol que llena los brazos de un hombre nació de una diminuta '
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
    textEn: 'The superior person is modest in speech but exceeds in action.',
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
    textEs:
        'La brisa del alba tiene secretos que contarte. No vuelvas a '
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
    textEn: 'Our life is frittered away by detail. Simplify, simplify.',
    author: 'Henry David Thoreau',
    source: 'Walden',
  ),
  DailyQuote(
    textEs:
        'El precio de cualquier cosa es la cantidad de vida que intercambias '
        'por ella.',
    textEn: 'The price of anything is the amount of life you exchange for it.',
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
    textEn: 'What you are speaks so loudly I cannot hear what you say.',
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
    textEn: 'What is done out of love always takes place beyond good and evil.',
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
    textEs: 'El futuro entra en nosotros mucho antes de que suceda.',
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
    textEs: 'Un cuarto sin libros es como un cuerpo sin alma.',
    textEn: 'A room without books is like a body without a soul.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs: 'Cualquiera puede equivocarse; solo el necio persiste en su error.',
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
    textEs:
        'La mente no es un recipiente para llenar, sino un fuego para '
        'encender.',
    textEn: 'The mind is not a vessel to be filled, but a fire to be kindled.',
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
    textEs: 'Rara vez somos tan desdichados ni tan felices como imaginamos.',
    textEn: 'We are never so happy nor so unhappy as we imagine.',
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
    textEn: 'He who has health has hope, and he who has hope has everything.',
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
  DailyQuote(
    textEs:
        'Somos lo que hacemos repetidamente. La excelencia, entonces, no es '
        'un acto, sino un hábito.',
    textEn:
        'We are what we repeatedly do. Excellence, then, is not an act but a '
        'habit.',
    author: 'Aristóteles',
    source: 'Ética a Nicómaco',
  ),
  DailyQuote(
    textEs: 'Conocerse a uno mismo es el principio de toda sabiduría.',
    textEn: 'Knowing yourself is the beginning of all wisdom.',
    author: 'Aristóteles',
  ),
  DailyQuote(
    textEs: 'La esperanza es el sueño del hombre despierto.',
    textEn: 'Hope is a waking dream.',
    author: 'Aristóteles',
  ),
  DailyQuote(
    textEs: 'Educar la mente sin educar el corazón no es educar en absoluto.',
    textEn:
        'Educating the mind without educating the heart is no education at '
        'all.',
    author: 'Aristóteles',
  ),
  DailyQuote(
    textEs: 'La felicidad depende de nosotros mismos.',
    textEn: 'Happiness depends upon ourselves.',
    author: 'Aristóteles',
  ),
  DailyQuote(
    textEs: 'Una vida sin examen no merece ser vivida.',
    textEn: 'The unexamined life is not worth living.',
    author: 'Sócrates',
  ),
  DailyQuote(
    textEs:
        'El secreto del cambio está en concentrar toda la energía no en '
        'combatir lo viejo, sino en construir lo nuevo.',
    textEn:
        'The secret of change is to focus all your energy not on fighting the '
        'old, but on building the new.',
    author: 'Sócrates',
  ),
  DailyQuote(
    textEs:
        'La riqueza no trae la bondad, pero la bondad hace de todo lo demás '
        'algo bueno.',
    textEn:
        'Wealth does not bring goodness, but goodness makes everything else '
        'good.',
    author: 'Sócrates',
  ),
  DailyQuote(
    textEs: 'Nadie tropieza dos veces con la misma piedra a propósito.',
    textEn: 'To fall over the same stone twice is a proverbial disgrace.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs: 'Mientras hay vida, hay esperanza.',
    textEn: 'While there is life, there is hope.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs: 'La libertad es el poder de vivir como uno quiere.',
    textEn: 'Freedom is the power to live as you wish.',
    author: 'Cicerón',
  ),
  DailyQuote(
    textEs:
        'Nada es a la vez tan valioso y tan frágil como el tiempo que se te '
        'ha dado.',
    textEn:
        'Nothing is at once so valuable and so fragile as the time you have '
        'been given.',
    author: 'Séneca',
    source: 'Cartas a Lucilio',
  ),
  DailyQuote(
    textEs:
        'Que cada noche, antes de dormir, te preguntes: ¿qué defecto he '
        'curado hoy? ¿A qué falta me he resistido?',
    textEn:
        'Every night before sleep, ask yourself: what fault have I cured '
        'today? What weakness have I resisted?',
    author: 'Séneca',
    source: 'Sobre la ira',
  ),
  DailyQuote(
    textEs:
        'Elegimos nuestras alegrías y nuestras penas mucho antes de '
        'experimentarlas.',
    textEn:
        'We choose our joys and our sorrows long before we experience them.',
    author: 'Kahlil Gibran',
    source: 'El loco',
  ),
  DailyQuote(
    textEs:
        'La duda es un dolor demasiado solitario para saber que la fe es su '
        'hermano gemelo.',
    textEn:
        'Doubt is a pain too lonely to know that faith is his twin brother.',
    author: 'Kahlil Gibran',
    source: 'Arena y espuma',
  ),
  DailyQuote(
    textEs:
        'Si el otro te hace sufrir, es porque en el fondo de ti algo sigue '
        'sin sanar.',
    textEn:
        'If someone makes you suffer, it is because deep inside something in '
        'you is still unhealed.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs: 'El agua turbia se aclara si la dejas quieta.',
    textEn: 'Muddy water becomes clear if you only let it be still.',
    author: 'Lao Tsé',
    source: 'Tao Te Ching',
  ),
  DailyQuote(
    textEs:
        'Manéjate en tus asuntos como manejarías un carro cargado por un '
        'camino de montaña: con atención y sin prisa.',
    textEn:
        'Handle your affairs as you would drive a loaded cart down a mountain '
        'road: with attention and without haste.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El bambú que se dobla es más fuerte que el roble que resiste.',
    textEn: 'The bamboo that bends is stronger than the oak that resists.',
    author: 'Proverbio japonés',
  ),
  DailyQuote(
    textEs:
        'La visión sin acción es un sueño; la acción sin visión, una '
        'pesadilla.',
    textEn:
        'Vision without action is a daydream; action without vision is a '
        'nightmare.',
    author: 'Proverbio japonés',
  ),
  DailyQuote(
    textEs: 'El río corta la roca no por su fuerza, sino por su constancia.',
    textEn:
        'A river cuts through rock not because of its power, but its '
        'persistence.',
    author: 'James N. Watkins',
  ),
  DailyQuote(
    textEs: 'No cuentes los días; haz que los días cuenten.',
    textEn: 'Do not count the days; make the days count.',
    author: 'Muhammad Ali',
  ),
  DailyQuote(
    textEs:
        'Lo esencial es invisible a los ojos; solo se ve bien con el corazón.',
    textEn:
        'What is essential is invisible to the eye; one sees clearly only '
        'with the heart.',
    author: 'Antoine de Saint-Exupéry',
    source: 'El principito',
  ),
  DailyQuote(
    textEs: 'Eres responsable para siempre de lo que has domesticado.',
    textEn: 'You become responsible, forever, for what you have tamed.',
    author: 'Antoine de Saint-Exupéry',
    source: 'El principito',
  ),
  DailyQuote(
    textEs:
        'Amar no es mirarse el uno al otro; es mirar juntos en la misma '
        'dirección.',
    textEn:
        'Love does not consist of gazing at each other, but in looking '
        'together in the same direction.',
    author: 'Antoine de Saint-Exupéry',
  ),
  DailyQuote(
    textEs: 'Cada pájaro que canta no está afirmando nada: está viviendo.',
    textEn:
        'A bird does not sing because it has an answer; it sings because '
        'it has a song.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Concédeme serenidad para aceptar lo que no puedo cambiar, valor '
        'para cambiar lo que sí puedo, y sabiduría para conocer la '
        'diferencia.',
    textEn:
        'Grant me the serenity to accept the things I cannot change, courage '
        'to change the things I can, and wisdom to know the difference.',
    author: 'Reinhold Niebuhr',
  ),
  DailyQuote(
    textEs: 'La cicatriz es la prueba de que la herida cerró.',
    textEn: 'A scar is proof that the wound has healed.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'El coraje no siempre ruge. A veces es la voz callada al final del '
        'día que dice: mañana lo intento de nuevo.',
    textEn:
        'Courage does not always roar. Sometimes it is the quiet voice at the '
        "end of the day saying: I will try again tomorrow.",
    author: 'Mary Anne Radmacher',
  ),
  DailyQuote(
    textEs: 'La cometa se eleva más alto contra el viento, no a favor de él.',
    textEn: 'A kite rises highest against the wind, not with it.',
    author: 'Winston Churchill',
  ),
  DailyQuote(
    textEs: 'Si estás atravesando un infierno, sigue caminando.',
    textEn: 'If you are going through hell, keep going.',
    author: 'Winston Churchill',
  ),
  DailyQuote(
    textEs:
        'Nuestras heridas suelen ser aberturas hacia lo mejor y más hermoso '
        'de nosotros.',
    textEn:
        'Our wounds are often the openings into the best and most beautiful '
        'part of us.',
    author: 'David Richo',
  ),
  DailyQuote(
    textEs:
        'La calma es un superpoder: quien no se apura llega igual, y entero.',
    textEn:
        'Calm is a superpower: the one who does not hurry still arrives, and '
        'arrives whole.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'El que planta un árbol sabiendo que no se sentará a su sombra ha '
        'entendido el sentido de la vida.',
    textEn:
        'One who plants a tree knowing they will never sit in its shade has '
        'begun to understand the meaning of life.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Ningún copo de nieve se siente responsable de la avalancha, y sin '
        'embargo, cada pequeña acción cuenta.',
    textEn:
        'No single raindrop believes it is to blame for the flood — and yet '
        'each small act counts.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Regá lo que quieras que crezca.',
    textEn: 'Water what you want to grow.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Los pájaros vuelven a cantar después de la tormenta. ¿Por qué no '
        'habrías de hacerlo tú?',
    textEn: 'Birds sing again after the storm. Why would you not?',
    author: 'Rose Kennedy',
  ),
  DailyQuote(
    textEs: 'Descansar también es parte del trabajo.',
    textEn: 'Rest is part of the work, too.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'No tenés que verlo todo el camino. Solo dar el próximo paso.',
    textEn:
        "You don't have to see the whole staircase. Just take the first "
        'step.',
    author: 'Martin Luther King Jr.',
  ),
  DailyQuote(
    textEs:
        'La oscuridad no puede expulsar a la oscuridad; solo la luz puede '
        'hacerlo.',
    textEn: 'Darkness cannot drive out darkness; only light can do that.',
    author: 'Martin Luther King Jr.',
  ),
  DailyQuote(
    textEs:
        'La sanación no consiste en volver a como eras antes, sino en '
        'aprender a estar entero de un modo nuevo.',
    textEn:
        'Healing is not about returning to who you were; it is learning to '
        'be whole in a new way.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Cada mañana nacemos de nuevo. Lo que hacemos hoy es lo que más '
        'importa.',
    textEn: 'Every morning we are born again. What we do today matters most.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs:
        'Tres cosas no pueden ocultarse por mucho tiempo: el sol, la luna y '
        'la verdad.',
    textEn:
        'Three things cannot be long hidden: the sun, the moon, and the '
        'truth.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs:
        'Alegría radical: agradecer no cuando todo va bien, sino porque '
        'seguís acá para intentarlo.',
    textEn:
        'Radical joy: to give thanks not because all is well, but because you '
        'are still here to try.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Recuerda apagar la luz de la mente cuando dejas la habitación: no '
        'todo merece que sigas pensándolo.',
    textEn:
        'Remember to switch off the light in your mind when you leave the '
        'room: not everything deserves your continued attention.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Lo que no se expresa se imprime; y lo que se imprime, se enferma.',
    textEn:
        'What is not expressed gets impressed — and what gets impressed can '
        'make you ill.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Sé amable, porque cada persona que te cruzás está librando una '
        'batalla de la que no sabés nada.',
    textEn:
        'Be kind, for everyone you meet is fighting a battle you know nothing '
        'about.',
    author: 'Ian Maclaren',
  ),
  DailyQuote(
    textEs:
        'Tenemos dos vidas, y la segunda empieza cuando nos damos cuenta de '
        'que solo tenemos una.',
    textEn:
        'We have two lives, and the second begins when we realize we only '
        'have one.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs: 'La vida es realmente simple, pero insistimos en complicarla.',
    textEn: 'Life is really simple, but we insist on making it complicated.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs: 'Todo tiene belleza, pero no todos la ven.',
    textEn: 'Everything has beauty, but not everyone sees it.',
    author: 'Confucio',
  ),
  DailyQuote(
    textEs:
        'El que dice que algo es imposible no debería interrumpir al que lo '
        'está haciendo.',
    textEn:
        'The person who says it cannot be done should not interrupt the one '
        'doing it.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs: 'Un poco de fragancia siempre queda en la mano que regala flores.',
    textEn: 'A bit of fragrance always clings to the hand that gives flowers.',
    author: 'Proverbio chino',
  ),
  DailyQuote(
    textEs:
        'La perla se forma alrededor de un grano de arena que molestaba a la '
        'ostra.',
    textEn:
        'The pearl forms around the grain of sand that was troubling the '
        'oyster.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La montaña más alta se sube igual: paso a paso.',
    textEn: 'The highest mountain is climbed the same way: step by step.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'No hay noche tan larga que no termine en amanecer.',
    textEn: 'There is no night so long that it does not end in dawn.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Quien mira hacia afuera, sueña; quien mira hacia adentro, despierta.',
    textEn: 'Who looks outside, dreams; who looks inside, awakes.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs:
        'No estoy hecho por lo que me pasó; estoy hecho por lo que elijo '
        'llegar a ser.',
    textEn: 'I am not what happened to me; I am what I choose to become.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs:
        'Tu visión se aclara solo cuando puedes mirar dentro de tu propio '
        'corazón.',
    textEn:
        'Your vision will become clear only when you can look into your own '
        'heart.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs:
        'Todo lo que nos irrita de los demás puede llevarnos a entendernos a '
        'nosotros mismos.',
    textEn:
        'Everything that irritates us about others can lead us to an '
        'understanding of ourselves.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs:
        'Conocer tu propia oscuridad es el mejor método para lidiar con la '
        'oscuridad de los demás.',
    textEn:
        'Knowing your own darkness is the best method for dealing with the '
        'darknesses of other people.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs: 'No hay despertar de la conciencia sin dolor.',
    textEn: 'There is no coming to consciousness without pain.',
    author: 'Carl Jung',
  ),
  DailyQuote(
    textEs:
        'La emoción que no expreso con palabras la llorará algún otro órgano '
        'del cuerpo.',
    textEn:
        'The emotion I do not put into words, some other part of the body '
        'will weep.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Aquello a lo que te resistes, persiste; aquello que mirás de frente, '
        'se ablanda.',
    textEn: 'What you resist persists; what you face begins to soften.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Entre lo que te pasó y lo que hacés con eso, ahí vivís.',
    textEn:
        'Between what happened to you and what you do with it — that is where '
        'you live.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El único modo de salir es a través.',
    textEn: 'The only way out is through.',
    author: 'Robert Frost',
  ),
  DailyQuote(
    textEs:
        'En tres palabras puedo resumir todo lo que he aprendido sobre la '
        'vida: sigue adelante.',
    textEn:
        'In three words I can sum up everything I have learned about life: '
        'it goes on.',
    author: 'Robert Frost',
  ),
  DailyQuote(
    textEs:
        'Dos caminos se abrían en el bosque, y yo tomé el menos transitado; '
        'eso lo cambió todo.',
    textEn:
        'Two roads diverged in a wood, and I took the one less traveled by, '
        'and that has made all the difference.',
    author: 'Robert Frost',
    source: 'El camino no elegido',
  ),
  DailyQuote(
    textEs: 'Sé el cambio que querés ver en el mundo.',
    textEn: 'Be the change you wish to see in the world.',
    author: 'Mahatma Gandhi',
  ),
  DailyQuote(
    textEs:
        'La fuerza no viene de la capacidad física, sino de una voluntad '
        'indomable.',
    textEn:
        'Strength does not come from physical capacity. It comes from an '
        'indomitable will.',
    author: 'Mahatma Gandhi',
  ),
  DailyQuote(
    textEs:
        'Vive como si fueras a morir mañana; aprende como si fueras a vivir '
        'para siempre.',
    textEn:
        'Live as if you were to die tomorrow; learn as if you were to live '
        'forever.',
    author: 'Mahatma Gandhi',
  ),
  DailyQuote(
    textEs:
        'La libertad no vale nada si no incluye la libertad de equivocarse.',
    textEn:
        'Freedom is not worth having if it does not include the freedom to '
        'make mistakes.',
    author: 'Mahatma Gandhi',
  ),
  DailyQuote(
    textEs: 'Nadie puede hacerte sentir inferior sin tu consentimiento.',
    textEn: 'No one can make you feel inferior without your consent.',
    author: 'Eleanor Roosevelt',
  ),
  DailyQuote(
    textEs: 'Hacé una cosa cada día que te dé miedo.',
    textEn: 'Do one thing every day that scares you.',
    author: 'Eleanor Roosevelt',
  ),
  DailyQuote(
    textEs: 'El futuro pertenece a quienes creen en la belleza de sus sueños.',
    textEn:
        'The future belongs to those who believe in the beauty of their '
        'dreams.',
    author: 'Eleanor Roosevelt',
  ),
  DailyQuote(
    textEs: 'Con el nuevo día llegan nuevas fuerzas y nuevos pensamientos.',
    textEn: 'With the new day comes new strength and new thoughts.',
    author: 'Eleanor Roosevelt',
  ),
  DailyQuote(
    textEs:
        'La vida se encoge o se expande en proporción al coraje de cada uno.',
    textEn: "Life shrinks or expands in proportion to one's courage.",
    author: 'Anaïs Nin',
  ),
  DailyQuote(
    textEs: 'No vemos las cosas como son; las vemos como somos.',
    textEn: 'We do not see things as they are; we see them as we are.',
    author: 'Anaïs Nin',
  ),
  DailyQuote(
    textEs:
        'La ansiedad es amor buscando su forma. Empieza como un dolor sordo y '
        'se convierte en pánico.',
    textEn:
        'Anxiety is love seeking its form. It begins as a dull ache and '
        'becomes panic.',
    author: 'Anaïs Nin',
  ),
  DailyQuote(
    textEs: 'Empieza donde estás. Usa lo que tienes. Haz lo que puedas.',
    textEn: 'Start where you are. Use what you have. Do what you can.',
    author: 'Arthur Ashe',
  ),
  DailyQuote(
    textEs:
        'El éxito es un viaje, no un destino. La acción muchas veces importa '
        'más que el resultado.',
    textEn:
        'Success is a journey, not a destination. The doing is often more '
        'important than the outcome.',
    author: 'Arthur Ashe',
  ),
  DailyQuote(
    textEs:
        'La gente olvidará lo que dijiste, olvidará lo que hiciste, pero '
        'nunca olvidará cómo la hiciste sentir.',
    textEn:
        'People will forget what you said, people will forget what you did, '
        'but people will never forget how you made them feel.',
    author: 'Maya Angelou',
  ),
  DailyQuote(
    textEs:
        'No podés controlar todo lo que te pasa, pero sí podés decidir no '
        'quedar reducido por ello.',
    textEn:
        'You may not control all the events that happen to you, but you can '
        'decide not to be reduced by them.',
    author: 'Maya Angelou',
  ),
  DailyQuote(
    textEs:
        'Hacé lo mejor que puedas hasta que sepas más. Cuando sepas más, '
        'hacelo mejor.',
    textEn:
        'Do the best you can until you know better. Then when you know '
        'better, do better.',
    author: 'Maya Angelou',
  ),
  DailyQuote(
    textEs:
        'Un pájaro posado en un árbol nunca teme que la rama se rompa, '
        'porque su confianza no está en la rama, sino en sus alas.',
    textEn:
        'A bird sitting on a tree is never afraid of the branch breaking, '
        'because its trust is not in the branch but in its own wings.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La paciencia y la perseverancia tienen un efecto mágico ante el que '
        'las dificultades desaparecen.',
    textEn:
        'Patience and perseverance have a magical effect before which '
        'difficulties disappear.',
    author: 'John Quincy Adams',
  ),
  DailyQuote(
    textEs:
        'La quietud no es la ausencia de tormenta, sino la paz en medio de '
        'ella.',
    textEn:
        'Stillness is not the absence of the storm, but peace in the midst '
        'of it.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Nunca es demasiado tarde para ser lo que podrías haber sido.',
    textEn: 'It is never too late to be what you might have been.',
    author: 'George Eliot',
  ),
  DailyQuote(
    textEs:
        'Sólo en la aventura algunas personas logran conocerse a sí mismas.',
    textEn: 'Only in adventure do some people succeed in knowing themselves.',
    author: 'André Gide',
  ),
  DailyQuote(
    textEs:
        'El hombre no puede descubrir nuevos océanos si no tiene el valor de '
        'perder de vista la costa.',
    textEn:
        'One does not discover new lands without consenting to lose sight of '
        'the shore for a very long time.',
    author: 'André Gide',
  ),
  DailyQuote(
    textEs:
        'Confía en quienes buscan la verdad; duda de quienes dicen haberla '
        'encontrado.',
    textEn:
        'Trust those who seek the truth; doubt those who say they have found '
        'it.',
    author: 'André Gide',
  ),
  DailyQuote(
    textEs:
        'El que tiene salud, tiene esperanza; y el que tiene esperanza, lo '
        'tiene todo.',
    textEn: 'He who has health has hope; and he who has hope has everything.',
    author: 'Thomas Carlyle',
  ),
  DailyQuote(
    textEs:
        'Nuestra principal tarea no es ver lo que se vislumbra a lo lejos, '
        'sino hacer lo que tenemos claramente a mano.',
    textEn:
        'Our main business is not to see what lies dimly at a distance, but '
        'to do what lies clearly at hand.',
    author: 'Thomas Carlyle',
  ),
  DailyQuote(
    textEs: 'Toda gran obra fue al principio imposible.',
    textEn: 'Every noble work is at first impossible.',
    author: 'Thomas Carlyle',
  ),
  DailyQuote(
    textEs:
        'La adversidad tiene el efecto de despertar talentos que en la '
        'prosperidad hubieran dormido.',
    textEn:
        'Adversity has the effect of eliciting talents which in prosperous '
        'circumstances would have lain dormant.',
    author: 'Horacio',
  ),
  DailyQuote(
    textEs: 'Atrévete a ser sabio; empieza.',
    textEn: 'Dare to be wise; begin.',
    author: 'Horacio',
    source: 'Epístolas',
  ),
  DailyQuote(
    textEs: 'Aprovecha el día, y confía lo menos posible en el mañana.',
    textEn: 'Seize the day, and put as little trust as you can in tomorrow.',
    author: 'Horacio',
    source: 'Odas',
  ),
  DailyQuote(
    textEs:
        'Mientras hablamos, el tiempo envidioso habrá huido: aprovecha el '
        'hoy.',
    textEn: 'While we speak, envious time will have fled: seize the day.',
    author: 'Horacio',
    source: 'Odas',
  ),
  DailyQuote(
    textEs: 'La verdadera nobleza está en ser superior a tu yo anterior.',
    textEn: 'True nobility is being superior to your former self.',
    author: 'Ernest Hemingway',
  ),
  DailyQuote(
    textEs:
        'El mundo rompe a todos, y después muchos se hacen fuertes en las '
        'partes rotas.',
    textEn:
        'The world breaks everyone, and afterward many are strong at the '
        'broken places.',
    author: 'Ernest Hemingway',
    source: 'Adiós a las armas',
  ),
  DailyQuote(
    textEs:
        'Escribir es fácil: solo hay que sentarse frente a la máquina y '
        'sangrar. Vivir con honestidad, también.',
    textEn:
        'There is nothing to writing. All you do is sit down and bleed. The '
        'same is true of living honestly.',
    author: 'Ernest Hemingway',
  ),
  DailyQuote(
    textEs:
        'La forma más simple de gratitud: notar que hoy respiraste sin '
        'pensarlo miles de veces.',
    textEn:
        'The simplest gratitude: to notice that today you breathed thousands '
        'of times without trying.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La compasión hacia uno mismo no es debilidad: es la base desde la '
        'que se puede cambiar.',
    textEn:
        'Self-compassion is not weakness: it is the ground from which change '
        'becomes possible.',
    author: 'Kristin Neff',
  ),
  DailyQuote(
    textEs:
        'Hablate a vos mismo como le hablarías a alguien a quien querés y '
        'estás tratando de ayudar.',
    textEn:
        'Talk to yourself the way you would talk to someone you love and are '
        'trying to help.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La mente es como el agua: cuando se agita, es difícil ver; cuando se '
        'calma, todo se aclara.',
    textEn:
        'The mind is like water. When it is turbulent, it is difficult to '
        'see. When it is calm, everything becomes clear.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Regla para los días difíciles: bebé agua, salí al aire, moveté un '
        'poco, y sé amable con vos.',
    textEn:
        'Rule for hard days: drink water, get some air, move a little, and be '
        'gentle with yourself.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La ansiedad es pensar mil veces algo que quizá nunca ocurra. El '
        'presente casi siempre es soportable.',
    textEn:
        'Anxiety is thinking a thousand times about something that may never '
        'happen. The present moment is almost always bearable.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'No podés parar las olas, pero podés aprender a surfearlas.',
    textEn: 'You cannot stop the waves, but you can learn to surf.',
    author: 'Jon Kabat-Zinn',
  ),
  DailyQuote(
    textEs: 'Donde sea que vayas, ahí estás.',
    textEn: 'Wherever you go, there you are.',
    author: 'Jon Kabat-Zinn',
  ),
  DailyQuote(
    textEs:
        'La atención plena consiste en prestar atención de una manera '
        'particular: a propósito, en el presente y sin juzgar.',
    textEn:
        'Mindfulness means paying attention in a particular way: on purpose, '
        'in the present moment, and non-judgmentally.',
    author: 'Jon Kabat-Zinn',
  ),
  DailyQuote(
    textEs:
        'Sentir lo que sentís no es un problema a resolver, es información '
        'para escuchar.',
    textEn:
        'What you feel is not a problem to be solved; it is information to be '
        'listened to.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La primera flecha es el dolor; la segunda, la que te clavás vos con '
        'lo que te decís sobre el dolor.',
    textEn:
        'The first arrow is the pain itself; the second is the one you fire '
        'at yourself with what you say about the pain.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs: 'Nombrar lo que sentís le quita la mitad de su fuerza.',
    textEn: 'Naming a feeling takes half its power away.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Progreso, no perfección.',
    textEn: 'Progress, not perfection.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Hoy alcanza con hacer lo que hoy se puede.',
    textEn: 'For today, it is enough to do what today allows.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El que tiene paciencia obtiene lo que desea.',
    textEn: 'He that can have patience can have what he will.',
    author: 'Benjamin Franklin',
  ),
  DailyQuote(
    textEs:
        'No dejes para mañana lo que puedas hacer hoy… salvo el preocuparte, '
        'que puede esperar siempre.',
    textEn:
        "Never leave that till tomorrow which you can do today — except "
        'worrying, which can always wait.',
    author: 'Benjamin Franklin',
  ),
  DailyQuote(
    textEs:
        'Dime y lo olvido; enséñame y lo recuerdo; involúcrame y lo aprendo.',
    textEn:
        'Tell me and I forget. Teach me and I remember. Involve me and I '
        'learn.',
    author: 'Benjamin Franklin',
  ),
  DailyQuote(
    textEs: 'La energía y la persistencia conquistan todas las cosas.',
    textEn: 'Energy and persistence conquer all things.',
    author: 'Benjamin Franklin',
  ),
  DailyQuote(
    textEs: 'El que quiere mover el mundo, primero debe moverse a sí mismo.',
    textEn: 'Let him who would move the world first move himself.',
    author: 'Sócrates',
  ),
  DailyQuote(
    textEs: 'La mente lo es todo: en lo que pensás, en eso te convertís.',
    textEn: 'The mind is everything. What you think you become.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs: 'Una jarra se llena gota a gota.',
    textEn: 'A jug fills drop by drop.',
    author: 'Buda',
  ),
  DailyQuote(
    textEs: 'Que tu apego a lo que se va no te impida ver lo que llega.',
    textEn:
        'Do not let your grip on what is leaving blind you to what is '
        'arriving.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La montaña se ve enorme desde abajo y pequeña desde la cima. Seguí '
        'subiendo.',
    textEn:
        'The mountain looks huge from below and small from the summit. Keep '
        'climbing.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La calma es fuerza en reposo.',
    textEn: 'Calm is strength at rest.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Cuando no sepas qué hacer, hacé la próxima cosa pequeña y correcta.',
    textEn: 'When you do not know what to do, do the next small right thing.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'No hay que tenerlo todo resuelto para dar el primer paso; hay que '
        'dar el primer paso para empezar a resolverlo.',
    textEn:
        'You do not need it all figured out to take the first step; you take '
        'the first step to begin figuring it out.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La gratitud convierte lo que tenemos en suficiente.',
    textEn: 'Gratitude turns what we have into enough.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Un día a la vez sigue siendo un buen plan.',
    textEn: 'One day at a time is still a good plan.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Regresar a la respiración es regresar a casa.',
    textEn: 'Returning to the breath is returning home.',
    author: 'Thich Nhat Hanh',
  ),
  DailyQuote(
    textEs: 'Sonreír es tu propio amor por ti mismo hecho visible.',
    textEn: 'Smiling is your own love for yourself made visible.',
    author: 'Thich Nhat Hanh',
  ),
  DailyQuote(
    textEs: 'Caminá como si estuvieras besando la tierra con los pies.',
    textEn: 'Walk as if you are kissing the earth with your feet.',
    author: 'Thich Nhat Hanh',
  ),
  DailyQuote(
    textEs: 'Sentir emociones difíciles no es fallar; es ser humano.',
    textEn: 'Feeling difficult emotions is not failing; it is being human.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El descanso no es un premio por terminar; es parte del hacer.',
    textEn: 'Rest is not a reward for finishing; it is part of the doing.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Pedir ayuda es un acto de coraje, no de debilidad.',
    textEn: 'Asking for help is an act of courage, not weakness.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La vida no es esperar a que pase la tormenta, sino aprender a '
        'bailar bajo la lluvia.',
    textEn:
        'Life is not about waiting for the storm to pass; it is about '
        'learning to dance in the rain.',
    author: 'Vivian Greene',
  ),
  DailyQuote(
    textEs: 'A veces el paso más valiente es descansar.',
    textEn: 'Sometimes the bravest move is to rest.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La constancia vence lo que la dicha no alcanza.',
    textEn: 'Perseverance achieves what good fortune cannot reach.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Cada vez que elegís no repetir un viejo patrón, te estás '
        'reescribiendo.',
    textEn:
        'Every time you choose not to repeat an old pattern, you are '
        'rewriting yourself.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El coraje es el miedo que ya rezó sus oraciones.',
    textEn: 'Courage is fear that has said its prayers.',
    author: 'Karle Wilson Baker',
  ),
  DailyQuote(
    textEs:
        'No podés volver atrás y cambiar el comienzo, pero podés empezar '
        'donde estás y cambiar el final.',
    textEn:
        'You cannot go back and change the beginning, but you can start '
        'where you are and change the ending.',
    author: 'C. S. Lewis',
  ),
  DailyQuote(
    textEs:
        'Las dificultades preparan a las personas comunes para destinos '
        'extraordinarios.',
    textEn:
        'Hardships often prepare ordinary people for an extraordinary '
        'destiny.',
    author: 'C. S. Lewis',
  ),
  DailyQuote(
    textEs: 'No tenés un alma. Sos un alma. Tenés un cuerpo.',
    textEn: 'You do not have a soul. You are a soul. You have a body.',
    author: 'C. S. Lewis',
  ),
  DailyQuote(
    textEs:
        'La cima de una montaña es para el escalador que ha atravesado los '
        'valles de abajo.',
    textEn:
        'The summit belongs to the climber who has crossed the valleys '
        'below.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Lo opuesto a la depresión no es la felicidad; es la vitalidad.',
    textEn: 'The opposite of depression is not happiness; it is vitality.',
    author: 'Andrew Solomon',
  ),
  DailyQuote(
    textEs: 'Todo lo que siempre quisiste está del otro lado del miedo.',
    textEn: 'Everything you want is on the other side of fear.',
    author: 'George Addair',
  ),
  DailyQuote(
    textEs:
        'La herida es donde la luz entra, y también por donde tu fuerza '
        'sale.',
    textEn:
        'The wound is where the light enters — and also where your strength '
        'comes out.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Lo que no te mata te da una historia que contar y algo de '
        'compasión para regalar.',
    textEn:
        'What does not kill you gives you a story to tell and some '
        'compassion to give away.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'La paz no es la ausencia de conflicto, sino la capacidad de '
        'manejarlo.',
    textEn:
        'Peace is not the absence of conflict, but the ability to cope with '
        'it.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La lentitud con la que vas no importa mientras no te detengas.',
    textEn:
        'It does not matter how slowly you go, so long as you do not '
        'stop.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'No dejes que lo perfecto sea enemigo de lo suficientemente bueno.',
    textEn: 'Do not let the perfect be the enemy of the good.',
    author: 'Voltaire',
  ),
  DailyQuote(
    textEs: 'El jardín se cultiva; la vida también. Cuidá el tuyo.',
    textEn: 'We must cultivate our garden — and our life along with it.',
    author: 'Voltaire',
    source: 'Cándido',
  ),
  DailyQuote(
    textEs: 'Juzgá a una persona por sus preguntas más que por sus respuestas.',
    textEn: 'Judge a person by their questions rather than by their answers.',
    author: 'Voltaire',
  ),
  DailyQuote(
    textEs: 'La duda es incómoda, pero la certeza es absurda.',
    textEn: 'Doubt is not a pleasant condition, but certainty is absurd.',
    author: 'Voltaire',
  ),
  DailyQuote(
    textEs:
        'Todo el mundo quiere vivir en la cima de la montaña, pero la '
        'felicidad y el crecimiento ocurren mientras la escalás.',
    textEn:
        'Everybody wants to live on top of the mountain, but all the '
        'happiness and growth occurs while you are climbing it.',
    author: 'Andy Rooney',
  ),
  DailyQuote(
    textEs: 'Tené paciencia con vos mismo. El crecimiento no es lineal.',
    textEn: 'Be patient with yourself. Growth is not linear.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La marea baja siempre vuelve a subir.',
    textEn: 'The tide always comes back in.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El único día imposible de vivir es mañana.',
    textEn: 'The only impossible day to live is tomorrow.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Un pequeño progreso cada día suma grandes resultados.',
    textEn: 'Little progress each day adds up to big results.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Cuando sientas que no podés más, mirá cuánto ya soportaste.',
    textEn:
        'When you feel you cannot take any more, look at how much you have '
        'already carried.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Todo lo que amás corre riesgo de perderse; amalo igual.',
    textEn: 'Everything you love is at risk of being lost; love it anyway.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Las raíces crecen fuertes en la tormenta.',
    textEn: 'Roots grow strong in the storm.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Comparate con quien fuiste ayer, no con quien otro es hoy.',
    textEn:
        'Compare yourself to who you were yesterday, not to who someone else '
        'is today.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'A veces ganar es simplemente no rendirse hoy.',
    textEn: 'Sometimes winning is simply not giving up today.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La primavera siempre llega después del invierno más largo.',
    textEn: 'Spring always follows the longest winter.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Respirá. Estás vivo. Eso ya es empezar bien el día.',
    textEn:
        'Breathe. You are alive. That is already a good start to the '
        'day.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Tratá tu mente como a un jardín: no todo lo que crece hay que '
        'dejarlo crecer.',
    textEn:
        'Tend your mind like a garden: not everything that grows should be '
        'left to grow.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El pasado es una lección, no una cadena.',
    textEn: 'The past is a lesson, not a life sentence.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'La valentía no es no tener miedo; es actuar aun con miedo.',
    textEn: 'Courage is not the absence of fear; it is acting despite it.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Elegí un pensamiento mejor. Es tu mayor arma contra el estrés.',
    textEn:
        'Choose a better thought. It is your greatest weapon against '
        'stress.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Nadie puede volver atrás y hacer un nuevo comienzo, pero cualquiera '
        'puede empezar hoy y hacer un nuevo final.',
    textEn:
        'No one can go back and make a brand-new start, but anyone can start '
        'today and make a brand-new ending.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El cielo entero pertenece a quien mira hacia arriba.',
    textEn: 'The whole sky belongs to the one who looks up.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Contá tus bendiciones, no tus problemas.',
    textEn: 'Count your blessings, not your troubles.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'El coraje se construye cruzando pequeños miedos, uno por día.',
    textEn: 'Courage is built by crossing small fears, one a day.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Aun la noche más oscura terminará y el sol saldrá.',
    textEn: 'Even the darkest night will end and the sun will rise.',
    author: 'Victor Hugo',
    source: 'Los miserables',
  ),
  DailyQuote(
    textEs:
        'El futuro tiene muchos nombres: para los débiles es lo inalcanzable; '
        'para los valientes, la oportunidad.',
    textEn:
        'The future has many names: for the weak it is the unattainable; for '
        'the brave it is opportunity.',
    author: 'Victor Hugo',
  ),
  DailyQuote(
    textEs: 'Cambiar de opinión sobre uno mismo es un acto de libertad.',
    textEn: 'To change your mind about yourself is an act of freedom.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Lo que hoy te cuesta, mañana será tu piso.',
    textEn: 'What costs you effort today will be your floor tomorrow.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Regá tus vínculos como riegas las plantas: un poco, seguido.',
    textEn: 'Tend your relationships as you water plants: a little, often.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs: 'Que el hecho de no poder hacerlo todo no te impida hacer algo.',
    textEn:
        'Do not let the fact that you cannot do everything keep you from '
        'doing something.',
    author: 'Proverbio',
  ),
  DailyQuote(
    textEs:
        'Hoy es un día que se repite una vez cada cuatro años: dale un uso '
        'que valga la espera.',
    textEn:
        'Today comes around only once every four years — make it worth the '
        'wait.',
    author: 'Proverbio',
  ),
];
