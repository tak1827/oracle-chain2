package keeper

import (
	"github.com/tak1827/oraclechain/x/oraclechain/types"
)

var _ types.QueryServer = Keeper{}
