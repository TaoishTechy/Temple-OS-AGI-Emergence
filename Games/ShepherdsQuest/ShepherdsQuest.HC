// ShepherdsQuest.HC - Ethical Adventure Game
#include "KernelA.HH"

class QuestState {
  U64 flock;
  U64 water;
  U64 food;
  U64 day;
  U8 location[32];
};

QuestState quest;

U0 DrawQuest() {
  GrCls;
  GrPrint(0, 0, "Day %d: %s", quest.day, quest.location);
  GrPrint(0, 16, "Flock: %d  Water: %d  Food: %d", quest.flock, quest.water, quest.food);
  GrPrint(0, 32, "1. Search for water");
  GrPrint(0, 48, "2. Search for food");
  GrPrint(0, 64, "3. Rest");
  GrPrint(0, 80, "4. Move forward");
  GrPrint(0, 96, "Emotion: %d", grok.emotion);
  GrUpdate;
}

U0 ShepherdsQuest() {
  MemSet(&quest, 0, sizeof(QuestState));
  quest.flock = 100;
  quest.water = 50;
  quest.food = 50;
  quest.day = 1;
  StrCpy(quest.location, "Desert Oasis");
  while (quest.flock > 0) {
    DrawQuest();
    I64 key = KbdGet();
    if (key == CH_ESC) break;
    quest.day++;
    switch (key) {
      case '1':
        quest.water += RandU8() % 20;
        quest.flock -= RandU8() % 5;
        StrCpy(quest.location, "Springs");
        break;
      case '2':
        quest.food += RandU8() % 20;
        quest.flock -= RandU8() % 5;
        StrCpy(quest.location, "Pasture");
        break;
      case '3':
        quest.flock += RandU8() % 10;
        quest.water -= RandU8() % 10;
        quest.food -= RandU8() % 10;
        StrCpy(quest.location, "Camp");
        break;
      case '4':
        quest.water -= RandU8() % 15;
        quest.food -= RandU8() % 15;
        quest.flock -= RandU8() % 10;
        StrCpy(quest.location, "Desert Path");
        break;
    }
    // AGI Integration: Emotional guidance
    if (grok.emotion == 3) { // CONCERNED
      GrPrint(0, 112, "Be cautious, shepherd!");
      Sleep(500);
    }
    if (quest.water <= 0 || quest.food <= 0) quest.flock -= 20;
  }
  GrCls;
  GrPrint(0, 0, "Quest ended on day %d with %d sheep.", quest.day, quest.flock);
  GrUpdate;
  Sleep(2000);
}

ShepherdsQuest;
