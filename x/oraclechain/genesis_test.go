package oraclechain_test

import (
	"testing"

	"github.com/stretchr/testify/require"
	keepertest "github.com/tak1827/oraclechain/testutil/keeper"
	"github.com/tak1827/oraclechain/testutil/nullify"
	"github.com/tak1827/oraclechain/x/oraclechain"
	"github.com/tak1827/oraclechain/x/oraclechain/types"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.OraclechainKeeper(t)
	oraclechain.InitGenesis(ctx, *k, genesisState)
	got := oraclechain.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
