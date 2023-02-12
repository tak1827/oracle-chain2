package keeper_test

import (
	"context"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	keepertest "github.com/tak1827/oraclechain/testutil/keeper"
	"github.com/tak1827/oraclechain/x/oraclechain/keeper"
	"github.com/tak1827/oraclechain/x/oraclechain/types"
)

func setupMsgServer(t testing.TB) (types.MsgServer, context.Context) {
	k, ctx := keepertest.OraclechainKeeper(t)
	return keeper.NewMsgServerImpl(*k), sdk.WrapSDKContext(ctx)
}
