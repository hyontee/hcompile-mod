package com.blackhub.bronline.game.gui.radialmenuforcar.viewmodel;

import androidx.compose.runtime.internal.StabilityInferred;
import androidx.lifecycle.ViewModel;
import com.blackhub.bronline.game.gui.radialmenuforcar.netrowk.RadialMenuActionWithJSON;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import org.apache.commons.compress.harmony.unpack200.SegmentConstantPool;
import org.jetbrains.annotations.NotNull;

/* compiled from: RadialMenuViewModel.kt */
@StabilityInferred(parameters = 0)
@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u0011\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u000e\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\tJ\u0006\u0010\n\u001a\u00020\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000b"}, d2 = {"Lcom/blackhub/bronline/game/gui/radialmenuforcar/viewmodel/RadialMenuViewModel;", "Landroidx/lifecycle/ViewModel;", "actionWithJson", "Lcom/blackhub/bronline/game/gui/radialmenuforcar/netrowk/RadialMenuActionWithJSON;", SegmentConstantPool.INITSTRING, "(Lcom/blackhub/bronline/game/gui/radialmenuforcar/netrowk/RadialMenuActionWithJSON;)V", "sendServerThisOperation", "", "valueKey", "", "showMessageError", "app_siteRelease"}, k = 1, mv = {2, 2, 0}, xi = 48)
/* loaded from: classes4.dex */
public final class RadialMenuViewModel extends ViewModel {
    public static final int $stable = 8;

    @NotNull
    public final RadialMenuActionWithJSON actionWithJson;

    @Inject
    public RadialMenuViewModel(@NotNull RadialMenuActionWithJSON actionWithJson) {
        Intrinsics.checkNotNullParameter(actionWithJson, "actionWithJson");
        this.actionWithJson = actionWithJson;
    }

    public final void sendServerThisOperation(int valueKey) {
        this.actionWithJson.sendServerThisOperation(valueKey);
    }

    public final void showMessageError() {
        this.actionWithJson.showMessageError();
    }
}