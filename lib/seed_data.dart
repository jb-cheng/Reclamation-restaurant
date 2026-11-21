import 'dish.dart';

/// Starting menu seeded into the database on first launch.
/// Dishes and flavour text are from Arknights "Tales Within the Sand"
/// (Reclamation Algorithm) provisions; costs are made up for the assignment.
const List<Dish> seedFoods = [
  Dish(
    name: 'Crab Porridge',
    cost: 8.0,
    description: 'Mixed grain with granite grab meat added for a savory touch.\nCragpincers are tasty, but who was the first to try one?',
    image: 'assets/food/crab_porridge.png',
  ),
  Dish(
    name: 'Seasoned Rations',
    cost: 7.0,
    description: 'Simple, ready-to-eat seasoned food, making it reasonably palatable.\nThe original, unseasoned version was so disagreeable that it was classified as a dietary supplement rather than food.',
    image: 'assets/food/seasoned_rations.png',
  ),
  Dish(
    name: 'Crab Sashimi',
    cost: 6.0,
    description: 'All it takes is a few cuts and a quick rinse.\nA controversial dish. Some claim to feel like they grew a shell like a cragpincer after eating it, which may or may not be an allergic reaction.',
    image: 'assets/food/crab_sashimi.png',
  ),
  Dish(
    name: 'Pine-Smoked Bacon',
    cost: 9.0,
    description: 'The meat has been smoked to give it a rich pine aroma.\nPut a few slices on hot, steaming rice, and the scent of smoked meat fills the whole room.',
    image: 'assets/food/pine_smoked_bacon.png',
  ),
  Dish(
    name: 'Vacuum-Packed Minced Meat',
    cost: 10.0,
    description: 'Ready-to-eat meat and grains, prepared at low temperatures to ensure freshness.\nJust heat and enjoy. The wonders of science!',
    image: 'assets/food/vacuum_packed_minced_meat.png',
  ),
  Dish(
    name: 'Grilled Meat Wraps',
    cost: 9.0,
    description: 'Every country has its own ways of dining, and one is free to mix and match.\nOne would be well-advised not to try to put xiaolongbaos in wraps, or risk starting a riot.',
    image: 'assets/food/grilled_meat_wraps.png',
  ),
  Dish(
    name: "Hunter's Rice Wrap",
    cost: 8.0,
    description: "Made with whatever meat the hunter caught today.\nThe size of the wrap is a symbol of the hunter's skill, though some secretly stuff more grains in to make it bigger.",
    image: 'assets/food/hunters_rice_wrap.png',
  ),
  Dish(
    name: 'Super Thick Pie',
    cost: 11.0,
    description: 'Traditional Sargonian dish with tasty meat filling. A local favorite.\nBigger is better.',
    image: 'assets/food/super_thick_pie.png',
  ),
  Dish(
    name: 'Essence Cube',
    cost: 12.0,
    description: 'The nutrients that the human body needs have been extracted from meat and distilled into a cube.\nUnfortunately, its appearance is just as unappetizing as the name.',
    image: 'assets/food/essence_cube.png',
  ),
  Dish(
    name: 'Pan-Fried Meats on Rice',
    cost: 12.0,
    description: 'Made with a variety of different meats, offering a myriad of colors and flavors.\nPart of the fun is digging through the rice to find your favorite meat.',
    image: 'assets/food/pan_fried_meats_on_rice.png',
  ),
  Dish(
    name: 'Dehydrated Seasoned Jerky',
    cost: 13.0,
    description: 'Drying is one of the oldest and simplest ways to preserve food.\nA few small pieces hold a lot of calories, plenty to fill you up.',
    image: 'assets/food/dehydrated_seasoned_jerky.png',
  ),
  Dish(
    name: 'Sous Vide Meat',
    cost: 15.0,
    description: 'Cooked at a low temperature, then lightly grilled for flavor.\nIt is difficult to tell what beast it came from, but it hardly matters as long as it is tasty and filling.',
    image: 'assets/food/sous_vide_meat.png',
  ),
  Dish(
    name: 'Crabshell Rice',
    cost: 14.0,
    description: "Grains steamed in a crab shell, a regular sight on dinner tables in Sargon's rural areas.\nThose in the nomadic cities sometimes try some and find pride in Sargon's unique cuisine, but few among the tribes would agree with them.",
    image: 'assets/food/crabshell_rice.png',
  ),
  Dish(
    name: 'Pressure-Cooked Soup',
    cost: 16.0,
    description: 'Extremely rich soup made by cooking under pressure for an extended period, made into solid stock.\nRich and flavorful, yet melts in the mouth, as though you are eating a piece of cloud.',
    image: 'assets/food/pressure_cooked_soup.png',
  ),
  Dish(
    name: 'Crispy Meat and Chips',
    cost: 17.0,
    description: "Made with whatever meat you can find in the wastes and fried with taters cut into all shapes and sizes. Nomadic city dwellers whine about how it's too greasy, but wastelanders who need to work all day love it.",
    image: 'assets/food/crispy_meat_and_chips.png',
  ),
  Dish(
    name: 'Crab Paste',
    cost: 18.0,
    description: 'Premium meat has been added to emphasize the flavor and nutritious value of cragpincer.\nA little-known fact is that it also tries to emulate the texture of cragpincer.',
    image: 'assets/food/crab_paste.png',
  ),
  Dish(
    name: 'Condensed Calories',
    cost: 20.0,
    description: 'A small piece gives you enough energy to last the day.\nBe careful about mixing them with sugar cubes. Accidental ingestion will not cause any immediate harm, but that is a LOT of calories you are taking in.',
    image: 'assets/food/condensed_calories.png',
  ),
  Dish(
    name: 'Carbohydrate Fat Cube',
    cost: 22.0,
    description: 'Comprised of protein, fat, and carbohydrates according to the needs of the human body. Easy to make and carry.\nOften carried by explorers.',
    image: 'assets/food/carbohydrate_fat_cube.png',
  ),
  Dish(
    name: 'Higashinese Bento',
    cost: 25.0,
    description: 'Made with fresh seasonal produce, delivering a treat for the eyes and conveying Zen through plating.\nHigashinese chefs believe in achieving the best of both worlds in taste and appearance.',
    image: 'assets/food/higashinese_bento.png',
  ),
  Dish(
    name: 'Yanese Shanshui Essence',
    cost: 25.0,
    description: 'A dream in the cloudy mountains.\nTea, wine, wind, snow, you can taste it all.',
    image: 'assets/food/yanese_shanshui_essence.png',
  ),
  Dish(
    name: 'Kazimierzian Knight Supplement',
    cost: 26.0,
    description: 'The color alone excites the mind and arouses the desire to have it, turning heads even if one has already passed it by.\nA single sip fills you with energy. It has been in high demand due to rumors that the Radiant Knight drinks it.',
    image: 'assets/food/kazimierzian_knight_supplement.png',
  ),
  Dish(
    name: 'Columbian Molecular Capsule',
    cost: 24.0,
    description: 'A Rhine Lab product that rearranges the molecular structure of food. The capsule is tasty and very filling, reducing food intake while maintaining the same amount of satisfaction.\nGood for health, not so much for wellbeing.',
    image: 'assets/food/columbian_molecular_capsule.png',
  ),
  Dish(
    name: 'Lateran Holy Soup',
    cost: 27.0,
    description: 'The pure appearance is soothing, but the flavor creates strange mental images... of explosions?\nAnd why is it so damn sweet?',
    image: 'assets/food/lateran_holy_soup.png',
  ),
  Dish(
    name: 'Low-Pressure Dried Meat',
    cost: 28.0,
    description: 'Tear open the package to find savory salted meat within.\nMaking good jerky requires just the right mix of temperature and humidity, but the upside is that it can be kept for years. The only problem is the toughness...',
    image: 'assets/food/low_pressure_dried_meat.png',
  ),
  Dish(
    name: 'Folk Festive Feast',
    cost: 30.0,
    description: "Dancing around a fire, with a whole animal roasted over the fire as its skin becomes golden crispy and the fat seeps out of it. This is the highest honor given to guests of the jungle clans.\nFinish the entire dish, and you will be the clan's hero for the day.",
    image: 'assets/food/folk_festive_feast.png',
  ),
  Dish(
    name: 'Iberian Chitin Cube',
    cost: 32.0,
    description: "Since the Profound Silence, Iberians have had trouble securing enough food, so the locals had no choice but to process the unpalatable shell chitin and make it look tasty.\nThere's just one problem: eat too much leaves you with a dry mouth.",
    image: 'assets/food/iberian_chitin_cube.png',
  ),
];
