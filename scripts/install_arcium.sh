#!/bin/bash

# Configuration
BASE_URL="https://arcium.com/api"
INSTALL_DIR="${CARGO_HOME:-$HOME/.cargo}/bin"
RETRY_COUNT=3
RETRY_DELAY=5

# Logging and formatting
NC='\033[0m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
STEP_COUNT=0
STEP_TOTAL_PLACEHOLDER="7"

print_step() {
  STEP_COUNT=$((STEP_COUNT + 1))
  printf "${CYAN}➜${NC} ${BOLD}[%s/%s] %s...${NC}\n" "$STEP_COUNT" "$STEP_TOTAL_PLACEHOLDER" "$1"
}

print_sub_step() {
  printf "  ${CYAN}▪${NC} %s\n" "$1"
}

print_success() {
  printf "  ${GREEN}✔${NC} %s\n" "$1"
}

print_warning() {
  printf "  ${YELLOW}⚠${NC} %s\n" "$1"
}

print_error() {
  printf "  ${RED}✖${NC} %s\n" "$1"
}

print_header() {
  printf "\n${PURPLE}======== Arcium Tooling Installer ========${NC}\n\n"
}

print_footer() {
  printf "\n${PURPLE}========================================${NC}\n\n"
}

# Platform detection
detect_platform() {
  OS=$(uname -s)
  ARCH=$(uname -m)

  case "$OS" in
    Linux)
      PLATFORM_OS="linux"
      ;;
    Darwin)
      PLATFORM_OS="macos"
      ;;
    *)
      print_error "Unsupported operating system: $OS"
      exit 1
      ;;
  esac

  case "$ARCH" in
    x86_64)
      PLATFORM_ARCH="x86_64"
      ;;
    arm64 | aarch64)
      PLATFORM_ARCH="aarch64"
      ;;
    *)
      print_error "Unsupported architecture: $ARCH"
      exit 1
      ;;
  esac

  PLATFORM="${PLATFORM_OS}-${PLATFORM_ARCH}"
}

# Dependency checking
check_dependency() {
  if ! command -v "$1" &> /dev/null; then
    print_warning "$2 is not installed. Please install it to use all features of Arcium."
    return 1
  fi
  print_success "$2 is installed."
}

check_all_dependencies() {
  print_step "Checking for required dependencies"
  check_dependency "rustc" "Rust"
  check_dependency "solana" "Solana CLI"
  check_dependency "yarn" "Yarn"
  check_dependency "anchor" "Anchor"
  if ! docker --version &> /dev/null; then
    print_warning "Docker is not installed. Please install it to use Arcium localnet."
  else
    if ! docker-compose --version &> /dev/null; then
      print_warning "Docker Compose is not installed. Please install it to use Arcium localnet."
    else
      print_success "Docker and Docker Compose are installed."
    fi
  fi
}

install_linux_dependencies() {
  if [ "$PLATFORM_OS" = "linux" ]; then
    print_step "Installing Linux dependencies"
    sudo apt-get update
    sudo apt-get install -y pkg-config build-essential libudev-dev libssl-dev
  fi
}

# Path checking
check_path() {
  if [[ ":$PATH:" != ":$INSTALL_DIR:"* ]]; then
    print_warning "The installation directory ($INSTALL_DIR) is not in your PATH."
    echo "Please add the following line to your shell profile (e.g., ~/.bashrc, ~/.zshrc):"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
  fi
}

# Version fetching
get_latest_version() {
  print_step "Fetching the latest version of arcup"
  VERSION_URL="${BASE_URL}/v1/arcup/version/latest?platform=${PLATFORM}"
  LATEST_VERSION=$(curl -sSfL "$VERSION_URL")
  if [ -z "$LATEST_VERSION" ]; then
    print_error "Failed to fetch the latest version of arcup."
    exit 1
  fi
  print_success "Latest arcup version: $LATEST_VERSION"
}

# Download and install arcup
download_and_install_arcup() {
  print_step "Downloading and installing arcup"
  DOWNLOAD_URL="${BASE_URL}/v1/arcup/download/${LATEST_VERSION}?platform=${PLATFORM}"
  
  mkdir -p "$INSTALL_DIR"
  
  for i in $(seq 1 $RETRY_COUNT);
  do
    curl -# -L "$DOWNLOAD_URL" -o "$INSTALL_DIR/arcup"
    if [ $? -eq 0 ]; then
      break
    fi
    if [ $i -lt $RETRY_COUNT ]; then
      print_warning "Download failed. Retrying in $RETRY_DELAY seconds..."
      sleep $RETRY_DELAY
    else
      print_error "Failed to download arcup after $RETRY_COUNT attempts."
      exit 1
    fi
  done
  
  chmod +x "$INSTALL_DIR/arcup"
  print_success "arcup installed successfully."
}

# Install Arcium CLI
install_arcium_cli() {
  print_step "Installing Arcium CLI"
  "$INSTALL_DIR/arcup" install
  if [ $? -ne 0 ]; then
    print_error "Failed to install Arcium CLI."
    exit 1
  fi
  print_success "Arcium CLI installed successfully."
}

# Verification
verify_installation() {
  print_step "Verifying installation"
  if ! command -v arcup &> /dev/null; then
    print_error "arcup command not found. Please check your PATH."
    exit 1
  fi
  if ! command -v arcium &> /dev/null; then
    print_error "arcium command not found. Please check your PATH."
    exit 1
  fi
  print_success "arcup and arcium are ready to use."
}

# Summary
print_summary() {
  ARCIUM_VERSION=$($INSTALL_DIR/arcium --version)
  ARX_VERSION=$($INSTALL_DIR/arcup active arx)
  
  print_header
  echo -e "${GREEN}Installation successful!${NC}\n"
  echo -e "  ${BOLD}Arcium CLI version:${NC} $ARCIUM_VERSION"
  echo -e "  ${BOLD}Arx Node version:${NC}   $ARX_VERSION\n"
  echo -e "${BOLD}Next steps:${NC}"
  echo -e "  - Start a new project: ${CYAN}arcium init <project_name>${NC}"
  echo -e "  - Build your project:  ${CYAN}arcium build${NC}"
  echo -e "  - Run a localnet:      ${CYAN}arcium localnet${NC}\n"
  echo -e "For more information, visit:"
  echo -e "  - Documentation: ${UNDERLINE}https://docs.arcium.com/${NC}"
  echo -e "  - GitHub:        ${UNDERLINE}https://github.com/arcium-io${NC}"
  echo -e "  - Discord:       ${UNDERLINE}https://discord.gg/arcium${NC}"
  print_footer
}

# Help message
show_help() {
  echo "Arcium Tooling Installer"
  echo "Usage: ./install_arcium.sh [options]"
  echo ""
  echo "Options:"
  echo "  --help    Show this help message."
  echo "  --quiet   Suppress non-error output."
}

# Main script
main() {
  # Parse command-line options
  for arg in "$@"; do
    case $arg in
      --help)
        show_help
        exit 0
        ;;
      --quiet)
        exec >/dev/null
        ;;
    esac
  done

  print_header
  
  # Replace total steps placeholder after all steps are defined
  7=7
  SCRIPT_CONTENT=$(cat "$0")
  echo "$SCRIPT_CONTENT" | sed "s/$STEP_TOTAL_PLACEHOLDER/$7/g" > "$0.tmp" && mv "$0.tmp" "$0"
  
  detect_platform
  check_all_dependencies
  install_linux_dependencies
  check_path
  get_latest_version
  download_and_install_arcup
  install_arcium_cli
  verify_installation
  print_summary
}

main "$@"
