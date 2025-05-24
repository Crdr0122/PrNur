{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "taskstodo";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h5Z1t+uIrD31UawMGBEqBMgtlXq8WjSksnhR2tERWdo="; # Replace with actual hash
  };

  format = "pyproject";

  propagatedBuildInputs = with python3Packages; [
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools  # Required for build-backend
  ];

  doCheck = false; # Disable tests if not present or not needed

  meta = with lib; {
    description = "Manage Google Tasks from the command-line and sync tasks with other apps";
    homepage = "https://github.com/stephan49/taskstodo";
    license = licenses.mit;
  };
}
