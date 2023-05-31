/*
class DiseaseAdvisoryModel {
  int id;
  String name;
  String symptoms;
  List<String> affetectedPlants;
  String causes;
  String organicControl;
  String chemicalControl;
  String preventiveMeasures;
  List<String> images;

  DiseaseAdvisoryModel(
      {this.id,
        this.name,
        this.symptoms,
        this.affetectedPlants,
        this.causes,
        this.organicControl,
        this.chemicalControl,
        this.preventiveMeasures,
        this.images});

  DiseaseAdvisoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symptoms = json['symptoms'];
    affetectedPlants = json['affetected_plants'].cast<String>();
    causes = json['causes'];
    organicControl = json['organic_control'];
    chemicalControl = json['chemical_control'];
    preventiveMeasures = json['preventive_measures'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symptoms'] = this.symptoms;
    data['affetected_plants'] = this.affetectedPlants;
    data['causes'] = this.causes;
    data['organic_control'] = this.organicControl;
    data['chemical_control'] = this.chemicalControl;
    data['preventive_measures'] = this.preventiveMeasures;
    data['images'] = this.images;
    return data;
  }
}*/
class DiseaseAdvisoryModel {
  String name;
  String symptoms;
  String affectedPlant;
  String causes;
  String organicControl;
  String chemicalControl;
  String preventiveMeasures;
  String pre;
  String folderName;
  String fileFormat;
  String image1;
  String image2;
  String image3;
  String image4;
  Null image5;
  String image6;
  String image7;
  String image8;
  String image9;
  String image10;
  String image11;
  String image12;
  String image13;
  String image14;
  String image15;
  String image16;
  String image17;
  String image18;
  String image19;
  String image20;
  String image21;
  String image22;
  String image23;
  String image24;
  String image25;
  String image26;
  String image27;
  String image28;
  String image29;
  String image30;
  String image31;
  String image32;
  String image33;
  String image34;
  String image35;
  String image36;
  String image37;
  String image38;
  String image39;
  String image40;
  String image41;
  String image42;
  String image43;
  String image44;
  String image45;
  String image46;
  String image47;
  String image48;
  String image49;
  String image50;
  String image51;
  String image52;
  String image53;
  String image54;
  String image55;
  String image56;
  String image57;
  String image58;
  String image59;
  int id;

  DiseaseAdvisoryModel(
      {this.name,
        this.symptoms,
        this.affectedPlant,
        this.causes,
        this.organicControl,
        this.chemicalControl,
        this.preventiveMeasures,
        this.pre,
        this.folderName,
        this.fileFormat,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.image5,
        this.image6,
        this.image7,
        this.image8,
        this.image9,
        this.image10,
        this.image11,
        this.image12,
        this.image13,
        this.image14,
        this.image15,
        this.image16,
        this.image17,
        this.image18,
        this.image19,
        this.image20,
        this.image21,
        this.image22,
        this.image23,
        this.image24,
        this.image25,
        this.image26,
        this.image27,
        this.image28,
        this.image29,
        this.image30,
        this.image31,
        this.image32,
        this.image33,
        this.image34,
        this.image35,
        this.image36,
        this.image37,
        this.image38,
        this.image39,
        this.image40,
        this.image41,
        this.image42,
        this.image43,
        this.image44,
        this.image45,
        this.image46,
        this.image47,
        this.image48,
        this.image49,
        this.image50,
        this.image51,
        this.image52,
        this.image53,
        this.image54,
        this.image55,
        this.image56,
        this.image57,
        this.image58,
        this.image59,
        this.id});

  DiseaseAdvisoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symptoms = json['symptoms'];
    affectedPlant = json['affected_plant'];
    causes = json['causes'];
    organicControl = json['organic_control'];
    chemicalControl = json['chemical_control'];
    preventiveMeasures = json['preventive_measures'];
    pre = json['pre'];
    folderName = json['folder_name'];
    fileFormat = json['file_format'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    image4 = json['image4'];
    image5 = json['image5'];
    image6 = json['image6'];
    image7 = json['image7'];
    image8 = json['image8'];
    image9 = json['image9'];
    image10 = json['image10'];
    image11 = json['image11'];
    image12 = json['image12'];
    image13 = json['image13'];
    image14 = json['image14'];
    image15 = json['image15'];
    image16 = json['image16'];
    image17 = json['image17'];
    image18 = json['image18'];
    image19 = json['image19'];
    image20 = json['image20'];
    image21 = json['image21'];
    image22 = json['image22'];
    image23 = json['image23'];
    image24 = json['image24'];
    image25 = json['image25'];
    image26 = json['image26'];
    image27 = json['image27'];
    image28 = json['image28'];
    image29 = json['image29'];
    image30 = json['image30'];
    image31 = json['image31'];
    image32 = json['image32'];
    image33 = json['image33'];
    image34 = json['image34'];
    image35 = json['image35'];
    image36 = json['image36'];
    image37 = json['image37'];
    image38 = json['image38'];
    image39 = json['image39'];
    image40 = json['image40'];
    image41 = json['image41'];
    image42 = json['image42'];
    image43 = json['image43'];
    image44 = json['image44'];
    image45 = json['image45'];
    image46 = json['image46'];
    image47 = json['image47'];
    image48 = json['image48'];
    image49 = json['image49'];
    image50 = json['image50'];
    image51 = json['image51'];
    image52 = json['image52'];
    image53 = json['image53'];
    image54 = json['image54'];
    image55 = json['image55'];
    image56 = json['image56'];
    image57 = json['image57'];
    image58 = json['image58'];
    image59 = json['image59'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symptoms'] = this.symptoms;
    data['affected_plant'] = this.affectedPlant;
    data['causes'] = this.causes;
    data['organic_control'] = this.organicControl;
    data['chemical_control'] = this.chemicalControl;
    data['preventive_measures'] = this.preventiveMeasures;
    data['pre'] = this.pre;
    data['folder_name'] = this.folderName;
    data['file_format'] = this.fileFormat;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['image5'] = this.image5;
    data['image6'] = this.image6;
    data['image7'] = this.image7;
    data['image8'] = this.image8;
    data['image9'] = this.image9;
    data['image10'] = this.image10;
    data['image11'] = this.image11;
    data['image12'] = this.image12;
    data['image13'] = this.image13;
    data['image14'] = this.image14;
    data['image15'] = this.image15;
    data['image16'] = this.image16;
    data['image17'] = this.image17;
    data['image18'] = this.image18;
    data['image19'] = this.image19;
    data['image20'] = this.image20;
    data['image21'] = this.image21;
    data['image22'] = this.image22;
    data['image23'] = this.image23;
    data['image24'] = this.image24;
    data['image25'] = this.image25;
    data['image26'] = this.image26;
    data['image27'] = this.image27;
    data['image28'] = this.image28;
    data['image29'] = this.image29;
    data['image30'] = this.image30;
    data['image31'] = this.image31;
    data['image32'] = this.image32;
    data['image33'] = this.image33;
    data['image34'] = this.image34;
    data['image35'] = this.image35;
    data['image36'] = this.image36;
    data['image37'] = this.image37;
    data['image38'] = this.image38;
    data['image39'] = this.image39;
    data['image40'] = this.image40;
    data['image41'] = this.image41;
    data['image42'] = this.image42;
    data['image43'] = this.image43;
    data['image44'] = this.image44;
    data['image45'] = this.image45;
    data['image46'] = this.image46;
    data['image47'] = this.image47;
    data['image48'] = this.image48;
    data['image49'] = this.image49;
    data['image50'] = this.image50;
    data['image51'] = this.image51;
    data['image52'] = this.image52;
    data['image53'] = this.image53;
    data['image54'] = this.image54;
    data['image55'] = this.image55;
    data['image56'] = this.image56;
    data['image57'] = this.image57;
    data['image58'] = this.image58;
    data['image59'] = this.image59;
    data['id'] = this.id;
    return data;
  }
}
