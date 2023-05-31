class HealthModel {
  int dt;
  String type;
  int dc;
  int cl;
  Sun sun;
  Images image;
  Images tile;
  Stats stats;
  Images data;

  HealthModel(
      {this.dt,
        this.type,
        this.dc,
        this.cl,
        this.sun,
        this.image,
        this.tile,
        this.stats,
        this.data});

  HealthModel.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    type = json['type'];
    dc = json['dc'];
    cl = json['cl'];
    sun = json['sun'] != null ? new Sun.fromJson(json['sun']) : null;
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    tile = json['tile'] != null ? new Images.fromJson(json['tile']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    data = json['data'] != null ? new Images.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['type'] = this.type;
    data['dc'] = this.dc;
    data['cl'] = this.cl;
    if (this.sun != null) {
      data['sun'] = this.sun.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    if (this.tile != null) {
      data['tile'] = this.tile.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Sun {
  double elevation;
  double azimuth;

  Sun({this.elevation, this.azimuth});

  Sun.fromJson(Map<String, dynamic> json) {
    elevation = json['elevation'];
    azimuth = json['azimuth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['elevation'] = this.elevation;
    data['azimuth'] = this.azimuth;
    return data;
  }
}

class Images {
  String truecolor;
  String falsecolor;
  String ndvi;
  String evi;
  String evi2;
  String nri;
  String dswi;
  String ndwi;

  Images(
      {this.truecolor,
        this.falsecolor,
        this.ndvi,
        this.evi,
        this.evi2,
        this.nri,
        this.dswi,
        this.ndwi});

  Images.fromJson(Map<String, dynamic> json) {
    truecolor = json['truecolor'];
    falsecolor = json['falsecolor'];
    ndvi = json['ndvi'];
    evi = json['evi'];
    evi2 = json['evi2'];
    nri = json['nri'];
    dswi = json['dswi'];
    ndwi = json['ndwi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['truecolor'] = this.truecolor;
    data['falsecolor'] = this.falsecolor;
    data['ndvi'] = this.ndvi;
    data['evi'] = this.evi;
    data['evi2'] = this.evi2;
    data['nri'] = this.nri;
    data['dswi'] = this.dswi;
    data['ndwi'] = this.ndwi;
    return data;
  }
}

class Stats {
  String ndvi;
  String evi;
  String evi2;
  String nri;
  String dswi;
  String ndwi;

  Stats({this.ndvi, this.evi, this.evi2, this.nri, this.dswi, this.ndwi});

  Stats.fromJson(Map<String, dynamic> json) {
    ndvi = json['ndvi'];
    evi = json['evi'];
    evi2 = json['evi2'];
    nri = json['nri'];
    dswi = json['dswi'];
    ndwi = json['ndwi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ndvi'] = this.ndvi;
    data['evi'] = this.evi;
    data['evi2'] = this.evi2;
    data['nri'] = this.nri;
    data['dswi'] = this.dswi;
    data['ndwi'] = this.ndwi;
    return data;
  }
}