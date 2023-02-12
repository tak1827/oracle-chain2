package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/require"
	testkeeper "github.com/tak1827/oraclechain/testutil/keeper"
	"github.com/tak1827/oraclechain/x/oraclechain/types"
)

func TestGetParams(t *testing.T) {
	k, ctx := testkeeper.OraclechainKeeper(t)
	params := types.DefaultParams()

	k.SetParams(ctx, params)

	require.EqualValues(t, params, k.GetParams(ctx))
}
