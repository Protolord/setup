echo "Setting up git hooks..."
PROJROOT_DIR=$(git rev-parse --show-toplevel)
ln -sf ${PROJROOT_DIR}/githook/pre-push ${PROJROOT_DIR}/.git/hooks/pre-push
echo "Git hook 'pre-push' added"
