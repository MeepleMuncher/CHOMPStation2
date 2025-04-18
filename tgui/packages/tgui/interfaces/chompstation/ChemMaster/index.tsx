import { useBackend } from 'tgui/backend';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from 'tgui/interfaces/common/ComplexModal';
import { Window } from 'tgui/layouts';

import { analyzeModalBodyOverride } from './ChemMasterAnalyzeModalBodyOverride';
import { ChemMasterBeaker } from './ChemMasterBeaker';
import { ChemMasterBuffer } from './ChemMasterBuffer';
import { ChemMasterCustomization } from './ChemMasterCustomization';
import { ChemMasterProduction } from './ChemMasterProduction';
import type { Data } from './types';

export const ChemMaster = (props) => {
  const { data } = useBackend<Data>();
  const {
    condi,
    beaker,
    beaker_reagents = [],
    buffer_reagents = [],
    mode,
    loaded_pill_bottle,
    loaded_pill_bottle_name,
    loaded_pill_bottle_contents_len,
    loaded_pill_bottle_storage_slots,
    pillsprite,
    bottlesprite,
  } = data;
  return (
    <Window width={575} height={500}>
      <ComplexModal />
      <Window.Content scrollable className="Layout__content--flexColumn">
        <ChemMasterBeaker
          beaker={beaker}
          beakerReagents={beaker_reagents}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        <ChemMasterBuffer mode={mode} bufferReagents={buffer_reagents} />
        <ChemMasterProduction
          isCondiment={condi}
          bufferNonEmpty={buffer_reagents.length > 0}
          loaded_pill_bottle={loaded_pill_bottle}
          loaded_pill_bottle_name={loaded_pill_bottle_name || ''}
          loaded_pill_bottle_contents_len={loaded_pill_bottle_contents_len || 0}
          loaded_pill_bottle_storage_slots={
            loaded_pill_bottle_storage_slots || 0
          }
          pillsprite={pillsprite}
          bottlesprite={bottlesprite}
        />
        <ChemMasterCustomization
          loaded_pill_bottle={loaded_pill_bottle}
          loaded_pill_bottle_name={loaded_pill_bottle_name || ''}
          loaded_pill_bottle_contents_len={loaded_pill_bottle_contents_len || 0}
          loaded_pill_bottle_storage_slots={
            loaded_pill_bottle_storage_slots || 0
          }
        />
      </Window.Content>
    </Window>
  );
};

modalRegisterBodyOverride('analyze', analyzeModalBodyOverride);
