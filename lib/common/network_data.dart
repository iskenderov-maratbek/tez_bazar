class Network {
  static final String _ipAdress = '192.168.0.120';
  static final String _port = '3000';
  static getUrl({path, String? parameters}) => parameters == null
      ? 'http://$_ipAdress:$_port/$path'
      : 'http://$_ipAdress:$_port/$path?$parameters';
}
